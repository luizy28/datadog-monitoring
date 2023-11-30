# Create a new Datadog - Amazon Web Services integration
resource "datadog_integration_aws" "sandbox" {
  #account_id = "411854276167"
  account_id                 = data.aws_caller_identity.current.account_id
  role_name                  = "DatadogIntegrationRole"
  metrics_collection_enabled = "true"
  filter_tags                = ["Name:Ansible-Ubuntu"]
  host_tags                  = ["Name:Ansible-Ubuntu"]
  account_specific_namespace_rules = {
    auto_scaling = false
    opsworks     = false
  }
  #excluded_regions = ["us-east-1", "us-west-2"]
}

resource "datadog_monitor" "demo" {
  name               = "Kubernetes Pod Health"
  type               = "metric alert"
  message            = "Kubernetes Pods are not in an optimal health state. Notify: @operator"
  escalation_message = "Please investigate the Kubernetes Pods, @operator"
  priority           = 1

  query = "max(last_1m):sum:kubernetes.containers.running{short_image:demo} <= 1"

  monitor_thresholds {
    ok       = 3
    warning  = 2
    critical = 1
  }

  notify_no_data = true

  tags = ["app:demo", "env:demo"]
}