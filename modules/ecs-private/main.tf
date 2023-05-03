
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

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

# Role para acessar o Secrets Manager
resource "aws_iam_role" "ecs_role" {
  name = "ecs_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# Json policy documento
data "aws_iam_policy_document" "policy_document" {
  statement {
    effect = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.container_registry_secret.arn]
  }
}
# Policy com permissão para Secrets Manager
resource "aws_iam_policy" "policy" {
  name        = "secrets-manager-ecs-policy"
  path        = "/"
  description = "Policy para o container acessar o Secrets Mnager, que contém as credenciais do Gitlab"

  policy = data.aws_iam_policy_document.policy_document.json
}

# Attach da role com a policy
resource "aws_iam_role_policy_attachment" "ecs_role_attachment" {
  role = "${aws_iam_role.ecs_role.name}"
  policy_arn = aws_iam_policy.policy.arn
}

locals {
  env_vars = jsondecode(file("${path.module}/env.json"))

  container_definitions = [
    {
      name = var.family
      image = "${var.registry}:${var.image_version}"
      repositoryCredentials = {
        credentialsParameter = aws_secretsmanager_secret.container_registry_secret.arn
      }
      cpu = 10
      memory = 512
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      essential = true
      environment = [
        for env in local.env_vars : {
          name  = env.name
          value = env.value
        }
      ]
    }
  ]
} 
# TASK definition do container, necessita de uma role que consiga ler do secrets manager,
# além das env vars (file)
resource "aws_ecs_task_definition" "textract_task_definition" {
  family = "${var.family}"
  # container_definitions = data.template_file.template_container_definitions.rendered
  execution_role_arn = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode(local.container_definitions)
}


# Cluster que será associado ao task set rodável
# TO DO

# Task set rodável (a rodar na pipeline)
# TO DO
