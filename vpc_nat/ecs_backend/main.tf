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

module "acm" {
  source                   = "../modules/acm"
  domain_name              = local.domain_name
  subject_alternative_name = local.subject_alternative_name
}

module "ecr_repo" {
  source        = "../modules/ecr"
  ecr_repo_name = local.ecr_repo_name
}

// ECS Cluster and ECS Task Execution Role Policy for IAM
module "ecs_app_cluster" {
  source = "../modules/ecs"

  ecs_cluster_name = local.ecs_cluster_name
  project_name     = module.vpc.project_name
  vpc_id           = module.vpc.vpc_id
  region           = module.vpc.region

  ssl_certificate_arn = module.acm.acm_certificate_arn

  ecs_app_task_family = local.ecs_app_task_family
  ecs_app_task_name   = local.ecs_app_task_name
  container_port      = local.container_port

  ecr_repo_url = module.ecr_repo.repository_url

  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id

  alb_security_group_id = module.security_groups.alb_security_group_id
  ecs_security_group_id = module.security_groups.ecs_security_group_id
}

// AWS can automatically create EC2 instances in the ECS cluster and
// scale them based on load. But for this need to define:
// - Launch Template
// - Auto Scaling Group
// - Capacity Provider to connect ECS Cluster with ASG

// Currently not setting up this module 
// (Not sure if this works with Fargate)
# module "ec2" {
#   source = "../modules/ec2"

#   ecs_cluster_name = local.ecs_cluster_name
#   instance_type    = var.instance_type
#   aws_key_name     = local.aws_key_name
#   vpc_id           = module.vpc.vpc_id

#   aws_iam_instance_profile_name = module.ecs_app_cluster.aws_iam_instance_profile_name
#   ecs_security_group_id         = module.security_groups.ecs_security_group_id

#   public_subnet_az1_id = module.vpc.public_subnet_az1_id
#   public_subnet_az2_id = module.vpc.public_subnet_az2_id
# }
