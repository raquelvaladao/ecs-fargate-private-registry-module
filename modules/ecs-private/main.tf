
# Metadata do secret que guarda as credenciais do container registry no Gitlab
resource "aws_secretsmanager_secret" "container_registry_secret" {
  name = "gitlab-registry-credentials"
  description = "Access key com permissão read_registry e write_registry"
  recovery_window_in_days = 0
  tags = {
    App = "textract"
  }
}

# Dado do secret anterior
resource "aws_secretsmanager_secret_version" "container_registry_secret_data" {
  secret_id     = aws_secretsmanager_secret.container_registry_secret.id
  secret_string = jsonencode(var.gitlab_credentials)
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
  statement {
    effect = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["*"]
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
      logConfiguration = {
        logDriver = "awslogs"
        
        options = {
          awslogs-group = aws_cloudwatch_log_group.log_group.name
          awslogs-region = "sa-east-1"
          awslogs-stream-prefix = var.family
        }
      }
    }
  ]
} 
# TASK definition do container, necessita de uma role que consiga ler do secrets manager,
resource "aws_ecs_task_definition" "textract_task_definition" {
  family = "${var.family}"
  cpu = 1024
  memory = 2048
  execution_role_arn = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode(local.container_definitions)

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# Cluster que será associado ao task set rodável
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
  # default vpc e subnets
}

resource "aws_ecs_service" "service" {
  name                = "${var.app_name}"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  desired_count       = "${var.desired_count}"
  task_definition     = aws_ecs_task_definition.textract_task_definition.arn
  scheduling_strategy = "REPLICA"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100

  force_new_deployment = true
  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    security_groups = "${var.security_group_ids}"
    subnets         = "${var.subnet_ids}" #tem que ter HTTP/80 e HTTPS/443 liberados para acessar o secret manager
    assign_public_ip = true
  }

  triggers = {
    update = timestamp() 
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "log-group"
}
