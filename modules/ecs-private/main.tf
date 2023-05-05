
<<<<<<< HEAD
resource "aws_secretsmanager_secret" "container_registry_secret" {
  name = "registry-credentials"
=======
# Metadata do secret que guarda as credenciais do container registry no Gitlab
resource "aws_secretsmanager_secret" "container_registry_secret" {
  name = "gitlab-registry-credentials"
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
  description = "Access key com permissão read_registry e write_registry"
  recovery_window_in_days = 0
}

<<<<<<< HEAD
resource "aws_secretsmanager_secret_version" "container_registry_secret_data" {
  secret_id     = aws_secretsmanager_secret.container_registry_secret.id
  secret_string = jsonencode(var.registry_credentials)
=======
# Dado do secret anterior
resource "aws_secretsmanager_secret_version" "container_registry_secret_data" {
  secret_id     = aws_secretsmanager_secret.container_registry_secret.id
  secret_string = jsonencode(var.gitlab_credentials)
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com", "ecs.amazonaws.com"
      ]
    }
  }
}

<<<<<<< HEAD
# ECS Role
=======
# Role para acessar o Secrets Manager
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
resource "aws_iam_role" "ecs_role" {
  name = "ecs_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

<<<<<<< HEAD
# ECS Role Policy
=======
# Json policy documento
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
data "aws_iam_policy_document" "policy_document" {
  statement {
    effect = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.container_registry_secret.arn]
  }
  statement {
    effect = "Allow"
    actions   = [
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "cloudwatch:PutMetricData",
        "ec2:DescribeTags",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutSubscriptionFilter",
        "logs:PutLogEvents"
        ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
<<<<<<< HEAD

resource "aws_iam_policy" "policy" {
  name        = "secrets-manager-ecs-policy"
  path        = "/"
  description = "Policy para o container acessar o Secrets Mnager, que contém as credenciais do registry"
=======
# Policy com permissão para Secrets Manager
resource "aws_iam_policy" "policy" {
  name        = "secrets-manager-ecs-policy"
  path        = "/"
  description = "Policy para o container acessar o Secrets Mnager, que contém as credenciais do Gitlab"
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5

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
<<<<<<< HEAD
          containerPort = var.container_port
          hostPort      = var.host_port
=======
          containerPort = 8080
          hostPort      = 8080
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
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
<<<<<<< HEAD
          awslogs-region = var.region
=======
          awslogs-region = "sa-east-1"
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
          awslogs-stream-prefix = aws_cloudwatch_log_stream.log_stream.name
        }
      }
    }
  ]
<<<<<<< HEAD
}

resource "aws_ecs_task_definition" "app_task_definition" {
  family = "${var.family}"
  cpu = "${var.cpu}"
  memory = "${var.memory}"
=======
} 
# TASK definition do container, necessita de uma role que consiga ler do secrets manager,
resource "aws_ecs_task_definition" "app_task_definition" {
  family = "${var.family}"
  cpu = 1024
  memory = 2048
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
  execution_role_arn = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode(local.container_definitions)

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

<<<<<<< HEAD
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
=======
# Cluster que será associado ao task set rodável
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
  # default vpc e subnets
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
}

resource "aws_ecs_service" "service" {
  name                = "${var.app_name}"
  cluster             = aws_ecs_cluster.ecs_cluster.id
  desired_count       = "${var.desired_count}"
  task_definition     = aws_ecs_task_definition.app_task_definition.arn
  scheduling_strategy = "REPLICA"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  force_new_deployment = true
  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
<<<<<<< HEAD
    security_groups = "${var.security_group_ids}" # liberar porta 80/443
    subnets         = "${var.subnet_ids}" 
=======
    security_groups = "${var.security_group_ids}"
    subnets         = "${var.subnet_ids}" #tem que ter HTTP/80 e HTTPS/443 liberados para acessar o secret manager
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.app_name}-group"
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.app_name}-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
