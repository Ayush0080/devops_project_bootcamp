
locals {

  owners = var.business_division  
  environment = var.environment_name 
  name = "${local.owners}-${local.environment}"
  eks_cluster_name = "${local.name}-${var.cluster_name}" 
}
