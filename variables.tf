# Providers
variable "access_key" {
  description = "Access key do seu usuário da AWS"
}
variable "secret_key" {
  description = "Secret key do seu usuário da AWS"
}


# ECS Task definition
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