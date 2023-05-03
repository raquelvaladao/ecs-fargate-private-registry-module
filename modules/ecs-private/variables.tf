variable "gitlab_access_key" {
  description = "Access Key do seu repositórido do Gitlab com permissões mínimas para acessar o registry privado"
}

# ECS Task Definition
variable "app_name" {}
variable "registry" {}
variable "family" {}
variable "image_version" {}