 # Amazon Managed Service for Prometheus collects metrics for you
resource "aws_prometheus_workspace" "MyCluster" {
  alias = "MyCluster"

  logging_configuration {
    log_group_arn = "${aws_cloudwatch_log_group.prometheus_MyCluster.arn}:*"
  }
}

resource "aws_cloudwatch_log_group" "prometheus_MyCluster" {
  name              = "/aws/prometheus/MyCluster"
  retention_in_days = 7
}
