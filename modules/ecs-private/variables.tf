variable "registry_credentials" {}
variable "region" {}

# ECS Task Definition
variable "app_name" {}
variable "registry" {}
variable "family" {}
variable "image_version" {}
variable "ecs_cluster_name" {}
variable "container_port" {}
variable "host_port" {}
variable "cpu" {}
variable "memory" {}

# ECS Service
variable "desired_count" {}
variable "subnet_ids" {}
variable "security_group_ids" {}
variable "s3_env_file_arns" {}
