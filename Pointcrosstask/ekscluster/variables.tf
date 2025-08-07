variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "avaliable_zones" {
  description = "List of availability zones to use for the VPC"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"] 
}

variable "vpcname" {
  description = "Name of the VPC"
  type       = string
  default = "Pointcross-VPC"
}


variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "EKS-AutoModule-Cluster"
  
}


variable "eks_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.33"
  
}

variable "instance_type" {
  description = "The size of the Managed EC2 Nodes"
  type= string
  default = "t3.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the EKS worker nodes"
  type        = string
  default     = "C:\\Users\\jboyalla\\Downloads\\mynewkey.pem"
  
}