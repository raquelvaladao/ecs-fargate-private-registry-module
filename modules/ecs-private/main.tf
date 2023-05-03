
# Metadata do secret que guarda as credenciais do container registry no Gitlab
resource "aws_secretsmanager_secret" "container_registry_secret" {
  name = "gitlab-registry-credentials"
  description = "Access key com permissão read_registry e write_registry"
  tags = {
    App = "textract"
  }
}

# Dado do secret anterior
resource "aws_secretsmanager_secret_version" "container_registry_secret_data" {
  secret_id     = aws_secretsmanager_secret.container_registry_secret.id
  secret_string = var.gitlab_access_key
}

# Role para acessar o Secrets Manager
resource "aws_iam_role" "ecs_role" {
  name = "ecs_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "secretsmanager:GetSecretValue"
        Resource = aws_secretsmanager_secret.container_registry_secret.arn
      }
    ]
  })
}

# Json com as task definitions
data "template_file" "template_container_definitions" {
  template = "${file("definition.json.tpl")}"

  vars {
    family              = "${var.family}"
    name                = "${var.app_name}"
    version             = "${var.image_version}"
    secretArn           = aws_secretsmanager_secret.container_registry_secret.arn
    taskRoleArn         = aws_iam_role.ecs_role.arn
    privateRegistryUrl  = "${var.registry}"
    environment         = "${file("${path.module}/env.json")}"
  }
}


# TASK definition do container, necessita de uma role que consiga ler do secrets manager,
# além das env vars (file)
resource "aws_ecs_task_definition" "textract_task_definition" {
  family = "${var.family}"
  container_definitions = data.template_file.template_container_definitions.rendered
}