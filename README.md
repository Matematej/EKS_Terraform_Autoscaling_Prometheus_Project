# EKS Terraform Autoscaling Prometheus Project

In this project, we are going to use EKS Service Accounts to grant permissions to individual Pods. You can define a Service Account in service_account.yaml and attach IAM Roles with permissions to Pods based on what SA they're using. In our case, the application_pods SA is given auto-scaling permissions. 

  For the SA to work, it needs to be able to communicate with AWS IAM. This will be achieved by using an identity provider(IdP). 
###    The Workflow:
      1- SA provides security credentials. 
      2- Pods in your Cluster send the security creadentials to an IdP.
      3- The IdP accepts the security credentials and sends back a Security Token.
      4- Pods will turn the Security Token into temporary credentials by using AssumeRoleWithWebIdentity.
  As your Identity provider, can use either OpenID Connect(auth_OIDC.tf) OR SAML(auth_SAML.tf).

We are also going to be using logging: EKS Controller Logging and EKS Worker Nodes Logging using Prometheus and Grafana.
###    The Workflow:
      1- For your pods to be able to access/write to Amazon Managed Service for Prometheus, they will once again use IAM Role through OIDC. It's a Best practice to use separate SAs for different tasks or services (That's why we are using another SA for AMP and not the SA for autoscaling).
      2- Prometheus Agent will discover Service Monitors with the same label that's defined in prometheus.yaml.
      3- Metrics will be collected by AMP.
      4- Metrics will be queried by Grafana.

## How to run:
1. `git pull https://github.com/Matematej/EKS_Terraform_Project.git`
2. 
   - `terraform init`
   - `terraform plan`
   - `terraform apply`
3. `aws eks update-kubeconfig --region us-east-1 --name MyCluster`
4. Apply Kubernetes resources:
   - `kubectl create -f k8s/prometheus_operator_crd`
   - `kubectl apply -f k8s/application_pods`
   - `kubectl apply -f k8s/prometheus_operator`
   - `kubectl apply -f k8s/prometheus_agent`
   - `kubectl apply -f k8s/node_exporter`
   - `kubectl apply -f k8s/cadvisor`
   - `kubectl apply -f k8s/kube_state_metrics`
5. Create Username and Password for Grafana
   - `[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("username123"))`
   - `[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("password123"))`
6. `kubectl apply -R -f k8s/grafana` (Modify the `secret.yaml` BEFORE applying)
7. `kubectl label nodes --all role=general` (Application pods will only deploy to nodes labeled `role=general`)
8. `kubectl label namespace default monitoring=prometheus-agent` (Service monitors will only be discovered if they're in a namespace labeled `monitoring=prometheus-agent`)
9. `kubectl port-forward -n monitoring prometheus-agent-0 9090:9090`
10. `kubectl port-forward -n monitoring svc/grafana 3000`
11. Visit [http://localhost:9090]
12. Visit [http://localhost:3000]
13. `terraform destroy`