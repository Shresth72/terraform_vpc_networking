provider "aws" {
  region  = var.region
  profile = "default"
}

# Store state on S3 with SSE enabled
module "tf-state" {
  source      = "../modules/tf-state"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

module "vpc" {
  source                       = "../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

module "nat_gateway" {
  source                     = "../modules/nat_gateway"
  vpc_id                     = module.vpc.vpc_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

module "security_groups" {
  source = "../modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "ecr_repo" {
  source       = "../modules/ecr"
  ecr_repo_name = local.ecr_repo_name
}

// TODO: Understand ECS and ECS Task Execution Role
module "ecs_tasks_execution_role" {
  source       = "../modules/ecs_tasks_execution_role"
  project_name = module.vpc.project_name
}

