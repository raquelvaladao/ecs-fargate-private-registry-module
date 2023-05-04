output "rendered_policy" {
  value = data.aws_iam_policy_document.policy_document.json
}
output "container_definitions" {
  value = aws_ecs_task_definition.textract_task_definition.container_definitions
}
output "task_revision" {
  value = aws_ecs_service.service.task_definition
}