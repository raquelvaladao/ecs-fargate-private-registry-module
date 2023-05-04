# Providers
variable "access_key" {
  description = "Access key do seu usuário da AWS"
}
variable "secret_key" {
  description = "Secret key do seu usuário da AWS"
}


# ECS Task definition
variable "gitlab_credentials" {
  description = "Credenciais (username e access key) do seu repositórido do Gitlab com permissões mínimas para acessar o registry privado"

  default = {
    username = "value1"
    password = "value2"
  }

  type = map(string)
}

variable "app_name" {
  description = "Nome do container"
  default = "textract"
}
variable "registry" {
  description = "URL do registry privado da aplicação"
}
variable "family" {
  description = "Family da task definition"
}
variable "image_version" {
  description = "Versão da imagem do container no container registry"
  default = "latest"
}
variable "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  default = "textract-cluster"
}

# Service
variable "desired_count" {
  description = "Número de containers da task"
  default = 1
}

variable "subnet_ids" {
  description = "Ids das suas subnets nas quais a tas será deployada"
  default = []
}

variable "security_group_ids" {
  description = "Ids dos security groups utilizados"
  default = []
}
