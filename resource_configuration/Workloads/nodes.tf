 # The EC2 instances / EKS Nodes
   # IAM Role. Every good IAM Role should have at least 2 parts: sts:Assume and permissons.
resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

  # This AWS Managed policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

  # This AWS Managed policy provides the Amazon VPC CNI Plugin the permissions it requires to modify the IP address configuration on your EKS worker nodes.
  # This permission set allows the CNI to list, describe, and modify Elastic Network Interfaces on your behalf.
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

  # This AWS Managed policy provides read-only access to Amazon EC2 Container Registry repositories.
  # It allows us to download and use images from ECR repo.
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

  # EKS Node Group. Placing it in private subnet will give them Private IP.
resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.MyCluster.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    module.landing_zone.private-us-east-1a,
    module.landing_zone.private-us-east-1b
  ]

  capacity_type  = "SPOT"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  tags = {
    role = "general"
  }
}