In this project, we are going to use EKS Service Account to grant permissions to individual Pods. You can define a Service Accounts in deployment.yaml and attach an IAM Roles with permissions to Pods based on what SA they're using.

For the SA to work, it needs to be able to communicate with AWS IAM. This will be achieved by using an identity provider(IdP). 
  The Workflow:
    1- SA provides security credentials. 
    2- Pods in your Cluster send the security creadentials to an IdP.
    3- The IdP accepts the security credentials and sends back a Security Token.
    4- Pods will turn the Security Token into temporary credentials by using AssumeRoleWithWebIdentity.
As your Identity provider, can use either OpenID Connect(auth_OIDC.tf) OR SAML(auth_SAML.tf)

How to run:
  1- git pull
  2- Uncomment one of the Identity Providers and Cluster Autoscalers
  2- Uncomment one of the Cluster Autoscalers
  2- terraform init, terraform plan, terraform apply apply
  3- aws eks update-kubeconfig --region us-east-1 --name demo

configure deployment.yaml

5 - terraform destroy

arn:aws:iam::046029232490:role/eks-cluster-demo
