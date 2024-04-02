In this project, we are going to use EKS Service Account to grant permissions to individual Pods. You can define a Service Accounts in service_account.yaml and attach an IAM Roles with permissions to Pods based on what SA they're using. In our case, the SA is given auto-scaling permissions. 

We are also using EKS Controller Logging as well as EKS Worker Nodes Logging using Prometheus and Grafana.
  Prometheus is located in a helm branch

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
  3- aws eks update-kubeconfig --region us-east-1 --name MyCluster
  6- kubectl apply -f k8s/xxx.yaml

configure deployment.yaml

5 - terraform destroy

arn:aws:iam::046029232490:role/eks-cluster-demo


solving connection
how do I access the cluster from web?

My takeaways:
  1- Labels are used to identify and organize resources within the cluster. They play a crucial role in various aspects of managing and monitoring workloads and selectors.
