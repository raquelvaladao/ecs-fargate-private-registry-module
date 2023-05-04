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

  gitlab_access_key = "${var.gitlab_access_key}"
  app_name = "${var.app_name}"
  registry = "${var.registry}"
  family = "${var.family}"
  image_version = "${var.image_version}"
  ecs_cluster_name = "${var.ecs_cluster_name}"
}
