data "aws_iam_policy_document" "prometheus_MyCluster" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:monitoring:prometheus"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

 # IAM Role for accessing our AMP. Kubernetes SA will assume this Role to interact with AWS AMP.
resource "aws_iam_role" "prometheus_MyCluster" {
  assume_role_policy = data.aws_iam_policy_document.prometheus_MyCluster.json
  name               = "prometheus-MyCluster"
}

resource "aws_iam_policy" "prometheus_MyCluster_ingest_access" {
  name = "PrometheusMyClusterIngestAccess"

  policy = jsonencode({
    Statement = [{
      Action = [
             "aps:RemoteWrite",
             "aps:QueryMetrics",
             "aps:GetSeries",
             "aps:GetLabels",
             "aps:GetMetricMetadata"
      ]
      Effect   = "Allow"
      Resource = aws_prometheus_workspace.MyCluster.arn
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "prometheus_MyCluster_ingest_access" {
  role       = aws_iam_role.prometheus_MyCluster.name
  policy_arn = aws_iam_policy.prometheus_MyCluster_ingest_access.arn
}