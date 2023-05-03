variable "gitlab_access_key" {
  description = "Access Key do seu repositórido do Gitlab com permissões mínimas para acessar o registry privado"
}

# ECS Task Definition
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