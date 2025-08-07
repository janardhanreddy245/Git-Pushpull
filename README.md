
This project is basically to provision the EKS Kubernetes Cluster on AWS and deploy the nginx application onto it using Ansible.

Overview of the solution and tool selection rationale:

 Solving this problem starts first with creating the infrastructure and deploy nginx application onto it.

 	Steps Involved:
  	a.Create EKS Cluster
  	b.Install kubectl
  	c.Create the Kubernetes manifests
  	d.Deploy them onto the clusters

Tools used in this project:

 1.AWS CLI - To configure the environment to connect to AWS
 2.Terraform - IaaC
 3.Ansible   - Configuration Management


Step-by-step guide to provision infrastructure and deploy the application:

1.Infrastructure Provisioning:

Prerequisites:

The following tools needs to be installed on your system to create the resources.

 1.AWS CLI - To configure the environment to connect to AWS
 2.Terraform - To help run the terraform command

Took the advantage of modules supported by the community hosted at Terraform modules registry:

This project leverages the following two modules:

VPC: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

EKS:https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

The entire EKS-Cluster folder structure is as follows:

ekscluster 
  - provider.tf
  - variables.tf
  - outputs.tf
  - vpc.tf
  - eks-cluster.tf

Let's have a look at what each file is used for and what they do:

 a.provider.tf : This is basically instructs terraform to where it needs to create the infrastructure.
 b.variables.tf : This is used to variablablise the values used in the terraform configuration
 c.outputs.tf: This will print the values of the resources(i.e,vpcid,cluster name etc) onto the console instead of manually checking on the cloud platform. 
 d.vpc.tf: The cluster needs to be deployed on a VPC.So Used the the above vpc module and passed the required values to create VPC.
 e.eks-cluster.tf: This is used to create the EKS-cluster on AWS.

 Commands used to create infrastructure:
    a.terraform init
    b.terraform plan
    c.terrform apply --auto-approve

2. Deploy the application:

 
  Steps followed to install kubectl and deployed the application onto the Kubernetes cluster:

   1.Ansible Installation:

        a.Created an EC2 Control-node on AWS
        b.Installed Ansible on it using the command pip3 install ansible

  2.Check whether installed properly:
       command: ansible --version

  3. Written Ansible playbook to install kubectl using the ansible("shell" module) and configured the kube config file to connect to EKS Cluster deployed on the above step.

      Command:ansible-playbook kubectl-setup.yaml

  4.Created another file k8s-manifests-all.yaml to deploy the application onto the cluster.This file is basically has all the Kubernetes resource manifest files.

   The following resources are created on to the cluster using this file:
      a.Namespace tenant1
      b.Namespace tenant2
      c.Applied resourceQuota on tenant1
      d.Applied resourceQuota on tenant2
      e.Created deployment to run pods on tenant1 namespace
      f.Created deployment to run pods on tenant2 namespace
      g.Created service of type LoadBalancer on tenant1 namespace
      h.Created service of type LoadBalancer on tenant2 namespace
      g.Created Ingress to expose the application on tenant1
      i.Created Ingress to expose the application on tenant2

   Command to run the playbook: ansible-playbook k8s-all-manifests.yaml
 
To expose the application externally,i installed Nginx Ingress Controller using Helm.The commands are as follows.

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --create-namespace --namespace ingress-nginx \
  --set controller.publishService.enabled=true


The service associated with this Ingress Controller creates a Load Balancer on AWS. 

Instructions to access the deployed NGINX services

URL1:https://LOAD-BALANCER-PUBLIC-IP>/tenant1
URL2:https://LOAD-BALANCER-PUBLIC-IP>/tenant2

Flow of the request:

1.User hits this url:https://LOAD-BALANCER-PUBLIC-IP>/tenant1
2.This goes to the Load balancer in AWS
3.The Loadbalancer forwards the request to the nginx ingress controller
4.It checks the ingress resources and it finds the ingress with path /tenant1
5.Then it should route to the service associated with the path /tenant1
6.ClusterIP Service routes the request to the nginx pods in tenant1 namespace.

Resource cleanup instructions:

terraform destroy will delete all the resources created on AWS.




      

   
  
 


