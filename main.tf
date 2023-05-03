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


# Cria Task Definition com o container de um registry privado (Gitlab)
module "ecs-private" {
  source = "./modules/ecs-private"

  gitlab_access_key = ""
  app_name = ""
  registry = ""
  family = ""
  image_version = ""
}