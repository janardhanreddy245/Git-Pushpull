output "name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_id
  
}

output "name_vpc" {
  description = "Name of the VPC"
  value       = module.vpc.vpc_id
  
}

output "name_subnets" {
  description = "List of private subnets in the VPC"
  value       = module.vpc.private_subnets
}
output "name_public_subnets" {
  description = "List of public subnets in the VPC"
  value       = module.vpc.public_subnets
}   
