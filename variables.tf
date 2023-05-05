# Providers
variable "access_key" {
  description = "Access key do seu usuário da AWS"
}
variable "secret_key" {
  description = "Secret key do seu usuário da AWS"
}


# ECS Task definition
<<<<<<< HEAD
variable "registry_credentials" {
  description = "Credenciais (username e access key) do seu repositórido do registry privado com permissões mínimas para acessar o registry"
  sensitive = true
=======
variable "gitlab_credentials" {
  description = "Credenciais (username e access key) do seu repositórido do Gitlab com permissões mínimas para acessar o registry privado"

>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
  default = {
    username = "value1"
    password = "value2"
  }

  type = map(string)
}

variable "app_name" {
  description = "Nome do container"
  default = "app"
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
  default = "app-cluster"
}

# Service
variable "desired_count" {
  description = "Número de containers da task"
  default = 1
}
<<<<<<< HEAD
=======

>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
variable "subnet_ids" {
  description = "Ids das suas subnets nas quais a tas será deployada"
  default = []
}
<<<<<<< HEAD
=======

>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
variable "security_group_ids" {
  description = "Ids dos security groups utilizados"
  default = []
}
<<<<<<< HEAD
variable "region" {
  description = "Region dos recursos do module"
  default = "sa-east-1"
}
variable "container_port" {
  description = "Porta do container"
  default = 8080
}
variable "host_port" {
  description = "Porta do host"
  default = 8080
}
variable "cpu" {
  description = "CPU Units do container"
  default = 1024
}
variable "memory" {
  description = "Memória (MiB) do container"
  default = 2048
}
=======
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
