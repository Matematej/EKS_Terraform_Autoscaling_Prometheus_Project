/*
 # Get an authentication token
data "aws_eks_cluster_auth" "MyCluster" {
  name = data.aws_eks_cluster.MyCluster.id
}

data "aws_eks_cluster" "MyCluster" {
  name = "MyCluster"
}

 # Set up terraform to be able to authenticate and communicate with a Kubernetes cluster hosted on Amazon EKS
provider "kubernetes" {
  host                   = aws_eks_cluster.MyCluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.MyCluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.MyCluster.token
}
*/