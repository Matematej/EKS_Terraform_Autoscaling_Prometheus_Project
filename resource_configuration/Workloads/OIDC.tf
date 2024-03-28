 # In this project, we are going to use EKS Service Accounts to grant permissions to Pods. You can define a Service Accounts in deployment.yaml and attach an IAM Roles with permissions to Pods based on the SA they're using.
 # For the SA to work, it needs to be able to communicate with AWS IAM. This will be achieved by using IAM OIDC provider(IdP).
  # 1) SA provides security credentials. 
  # 2) Pods in your Cluster will send the security creadentials to OIDC.
  # 3) The OIDC will accept the security credentials and send back a Security Token.
  # 4) Pods will turn the token into temporary credentials by using AssumeRoleWithWebIdentity.

 # OpenID Connect provider
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}

  # Certificate for EKS
data "tls_certificate" "eks" {
  url = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}