
 # OpenID Connect provider
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.MyCluster.identity[0].oidc[0].issuer
}

  # Certificate for EKS
data "tls_certificate" "eks" {
  url = aws_eks_cluster.MyCluster.identity[0].oidc[0].issuer
}
