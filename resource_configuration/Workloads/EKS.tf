  # IAM Role. Every good IAM Role should have at least 2 parts: sts:Assume and permissons.
resource "aws_iam_role" "MyCluster_IAM_Role" {
  name = "eks-cluster-MyCluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}

 # This AWS Managed policy provides Kubernetes the permissions it requires to manage resources on your behalf.
resource "aws_iam_role_policy_attachment" "MyCluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.MyCluster_IAM_Role.name
}

 # Allow EKS control plane logging
resource "aws_iam_policy" "eks_control_plane_logs" {
  name   = "eks-control-plane-logs-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_control_plane_logs" {
  policy_arn = aws_iam_policy.eks_control_plane_logs.arn
  role       = aws_iam_role.MyCluster_IAM_Role.name
}

 # The EKS cluster 
resource "aws_eks_cluster" "MyCluster" {
  name     = "MyCluster"
  role_arn = aws_iam_role.MyCluster_IAM_Role.arn

  vpc_config {
    subnet_ids = [
      module.landing_zone.private-us-east-1a,
      module.landing_zone.private-us-east-1b,
      module.landing_zone.public-us-east-1a,
      module.landing_zone.public-us-east-1b
    ]
  }
 # Allow Control Plane logging
  enabled_cluster_log_types = ["api", "authenticator", "audit", "scheduler", "controllerManager"]
  depends_on                = [aws_iam_role_policy_attachment.MyCluster-AmazonEKSClusterPolicy]

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}

resource "aws_cloudwatch_log_group" "eks_control_plane_logs" {
  retention_in_days = 7
  name              = "/aws/eks/MyCluster/control_plane_logs"

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}