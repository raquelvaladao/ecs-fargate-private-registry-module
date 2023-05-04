variable "gitlab_credentials" {}

# ECS Task Definition
variable "app_name" {}
variable "registry" {}
variable "family" {}
variable "image_version" {}
variable "ecs_cluster_name" {}

# ECS Service
variable "desired_count" {}
variable "subnet_ids" {}
variable "security_group_ids" {}

