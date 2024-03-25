variable "vpc_id" {}

variable "project_name" {}
variable "ecs_cluster_name" {}

variable "ecs_app_task_family" {}
variable "ecs_app_task_name" {}

variable "ecr_repo_url" {}

variable "container_port" {}

variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}

variable "alb_security_group_id" {}
variable "ecs_security_group_id" {}

variable "ssl_certificate_arn" {}
