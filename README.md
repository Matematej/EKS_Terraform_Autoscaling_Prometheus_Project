In this project, we are going to use EKS Service Account to grant permissions to individual Pods. You can define a Service Accounts in service_account.yaml and attach an IAM Roles with permissions to Pods based on what SA they're using. In our case, the SA is given auto-scaling permissions. 

  For the SA to work, it needs to be able to communicate with AWS IAM. This will be achieved by using an identity provider(IdP). 
    The Workflow:
      1- SA provides security credentials. 
      2- Pods in your Cluster send the security creadentials to an IdP.
      3- The IdP accepts the security credentials and sends back a Security Token.
      4- Pods will turn the Security Token into temporary credentials by using AssumeRoleWithWebIdentity.
  As your Identity provider, can use either OpenID Connect(auth_OIDC.tf) OR SAML(auth_SAML.tf)

We are also using:
  EKS Controller Logging
  EKS Worker Nodes Logging using Prometheus and Grafana
    The Workflow:
      1- Metrics will be collected by Amazon Managed Service for Prometheus.
      2- For your pods to be able to access/write to AMP, they will once again use IAM Role through OIDC. It's a Best practice to use separate SAs for different tasks or services. That's why we are using another SA for AMP and not the SA for autoscaling.

How to run:
  1- git pull
  2- Uncomment one of the Identity Providers and Cluster Autoscalers
  2- Uncomment one of the Cluster Autoscalers
  2- terraform init, terraform plan, terraform apply apply
  3- aws eks update-kubeconfig --region us-east-1 --name MyCluster
  6- 
  kubectl create -f k8s/prometheus_operator_crd
  kubectl apply -f k8s/application_pods
  kubectl apply -f k8s/prometheus_operator
  kubectl apply -f k8s/prometheus_agent
  kubectl apply -f k8s/node_exporter
  kubectl apply -f k8s/cadvisor
  kubectl apply -f k8s/kube_state_metrics
  7- kubectl label nodes --all role=general
  kubectl label namespace default monitoring=prometheus-agent
  8- kubectl port-forward -n monitoring prometheus-agent-0 9090:9090
  9- http://localhost:9090
  10- terraform destroy

My takeaways:
  1- Labels are used to identify and organize resources within the cluster. They play a crucial role in various aspects of managing and monitoring workloads and selectors.