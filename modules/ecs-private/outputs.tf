output "rendered_policy" {
  value = data.aws_iam_policy_document.policy_document.json
}
output "container_definitions" {
<<<<<<< HEAD
  value = aws_ecs_task_definition.app_task_definition.container_definitions
=======
  value = aws_ecs_task_definition.textract_task_definition.container_definitions
>>>>>>> 01a16bf918ac4196fd6a631325fb259d92f4c1f5
}
output "task_revision" {
  value = aws_ecs_service.service.task_definition
}