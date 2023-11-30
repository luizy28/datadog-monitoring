data "aws_iam_policy_document" "datadog_assume_role" {
  statement {
    sid    = "AllowDatadogAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [datadog_integration_aws.sandbox.external_id]
    }
  }
}

resource "aws_iam_role" "datadog" {
  name               = "DatadogIntegrationRole"
  assume_role_policy = data.aws_iam_policy_document.datadog_assume_role.json
}

resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.datadog.name
  policy_arn = aws_iam_policy.datadog_policy.arn
}

resource "aws_iam_policy" "datadog_policy" {
  name   = "DatadogIntegrationPolicy"
  policy = data.aws_iam_policy_document.datadog.json
}