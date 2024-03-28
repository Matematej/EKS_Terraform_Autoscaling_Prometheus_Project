/*
#I thought I kept getting Unauthorized because of the tokens but no
data "aws_eks_cluster_auth" "demo" {
  name = data.aws_eks_cluster.demo.id
}

 data "aws_eks_cluster" "demo" {
  name = "demo"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.demo.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.demo.token
}
*/