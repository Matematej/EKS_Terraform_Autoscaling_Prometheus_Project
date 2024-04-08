data "aws_iam_policy_document" "grafana_MyCluster" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "grafana_MyCluster" {
  assume_role_policy = data.aws_iam_policy_document.grafana_MyCluster.json
  name               = "grafana-MyCluster"
}

 # This AWS Managed policy grants access to run queries against AWS Managed Prometheus resources.
resource "aws_iam_role_policy_attachment" "grafana_MyCluster_query_access" {
  role       = aws_iam_role.grafana_MyCluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusQueryAccess"
}