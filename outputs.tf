output "ecs_policy" {
  value = module.ecs-private.rendered_policy
}
output "task_revision" {
  value = module.ecs-private.task_revision
}

output "container_definitions" {
  value     = module.ecs-private.container_definitions
  sensitive = true
}