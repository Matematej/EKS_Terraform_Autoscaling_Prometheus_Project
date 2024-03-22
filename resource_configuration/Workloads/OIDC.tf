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

  # IAM Role that your Pods will assume. Every good IAM Role should have at least 2 parts: sts:Assume and permissons.
resource "aws_iam_role" "eks_cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_assume_role_policy.json
  name               = "eks-cluster-autoscaler"
}

  # In the condition.variable you need to provide the URI of your cluster's OIDC Identity Provider.
  # The URI is defined in the deployment.yaml in the SA section.
data "aws_iam_policy_document" "eks_cluster_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "<URI of your cluster's OIDC Identity Provider>:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

  # here you could define other permissions like access to other AWS resources
resource "aws_iam_policy" "eks_cluster_autoscaler" {
  name = "eks-cluster-autoscaler"

  policy = jsonencode({
    Statement = [{
      Action = [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attach" {
  role       = aws_iam_role.eks_cluster_autoscaler.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler.arn
}