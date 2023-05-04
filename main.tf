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
  region = "sa-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


# Cria Task Definition com o container de um registry privado (Gitlab) e suas ecs roles
module "ecs-private" {
  source = "./modules/ecs-private"

  # Task definition
  gitlab_credentials = "${var.gitlab_credentials}"
  app_name = "${var.app_name}"
  registry = "${var.registry}"
  family = "${var.family}"
  image_version = "${var.image_version}"

  # Cluster
  ecs_cluster_name = "${var.ecs_cluster_name}"

  # Service
  desired_count = "${var.desired_count}"
  subnet_ids = "${var.subnet_ids}"
  security_group_ids = "${var.security_group_ids}"
}