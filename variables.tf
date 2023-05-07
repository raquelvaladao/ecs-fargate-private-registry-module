# Providers
variable "access_key" {
  description = "Access key do seu usuário da AWS"
  sensitive   = true
}
variable "secret_key" {
  description = "Secret key do seu usuário da AWS"
  sensitive   = true
}

# ECS Task definition
variable "registry_credentials" {
  description = "Credenciais (username e access key) do seu repositórido do registry privado com permissões mínimas para acessar o registry"
  sensitive   = true
  default = {
    username = "value1"
    password = "value2"
  }

  type = map(string)
}

variable "s3_env_file_arns" {
  description = "Lista de ARNs do arquivo .env do S3. Ex.: arn:aws:s3:::s3_bucket_name/file.env"
  sensitive   = true
  default     = null
  type        = list(string)
}


variable "app_name" {
  description = "Nome do container"
  default     = "app"
}
variable "registry" {
  description = "URL do registry privado da aplicação"
  sensitive   = true
}
variable "family" {
  description = "Family da task definition"
  default     = "app-family"
}
variable "image_version" {
  description = "Versão da imagem do container no container registry"
  default     = "latest"
}
variable "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  default     = "app-cluster"
}

# Service
variable "desired_count" {
  description = "Número de containers da task"
  default     = 1
}
variable "subnet_ids" {
  description = "Ids das suas subnets nas quais a tas será deployada"
  type        = list(string)
  default     = []
}
variable "security_group_ids" {
  description = "Ids dos security groups utilizados"
  type        = list(string)
  default     = []
}
variable "region" {
  description = "Region dos recursos do module"
  default     = "sa-east-1"
}
variable "container_port" {
  description = "Porta do container"
  default     = 8080
}
variable "host_port" {
  description = "Porta do host"
  default     = 8080
}
variable "cpu" {
  description = "CPU Units do container"
  default     = 1024
}
variable "memory" {
  description = "Memória (MiB) do container"
  default     = 2048
}