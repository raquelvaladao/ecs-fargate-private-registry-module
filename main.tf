terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.55.0"
    }
    
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "ecs-private" {
  source = "./modules/ecs-private"

  region = "${var.region}"

  # Task definition
  registry_credentials = "${var.registry_credentials}"
  app_name = "${var.app_name}"
  registry = "${var.registry}"
  family = "${var.family}"
  image_version = "${var.image_version}"
  container_port = "${var.container_port}"
  host_port = "${var.host_port}"
  cpu = "${var.cpu}"
  memory = "${var.memory}"
  s3_env_file_arns = "${var.s3_env_file_arns}"

  # Cluster
  ecs_cluster_name = "${var.ecs_cluster_name}"
  # Service
  desired_count = "${var.desired_count}"
  subnet_ids = "${var.subnet_ids}"
  security_group_ids = "${var.security_group_ids}"
}