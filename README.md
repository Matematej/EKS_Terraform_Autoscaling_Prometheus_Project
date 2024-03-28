How to run:
  1 - apply resource configuration first
  2 - 
  ¨
If your using Cloud9 OR terraform cloud, you probably need to set environment variables for dynamic creadentials.
  
export TFC_AWS_PROVIDER_AUTH='true'
export TFC_AWS_RUN_ROLE_ARN='arn:aws:iam::046029232490:role/eks-cluster-demo'
export TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE=''
export TFC_AWS_PLAN_ROLE_ARN=''
export TFC_AWS_APPLY_ROLE_ARN=''


arn:aws:iam::046029232490:role/eks-cluster-demo

aws eks update-kubeconfig --region us-east-1 --name demo



eksctl utils write-kubeconfig --cluster demo --authenticator-role-arn 
