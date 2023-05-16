🇧🇷 [Português (Brasil)](README-pt.md) 

🇺🇸 [English (United States)](README.md)


# Container on ECS/Fargate with Private Registry and logs on CloudWatch

This is a module to upload a functional ECS-Fargate service running on ECS from an image of a private registry, with the proper configuration of logs in the container's CloudWatch Logs.

My use case is Gitlab Private Registry, but you can use your provider's username, password and URL.

I made this project to automate the creation of a personal side-project of mine in Java, containerized, made completely on AWS. At this point, there is only the backend part here in this repo, but I intend to extend it to the rest of the infrastructure in the future.

## Summary
- [Prerequisites](#Prerequisites)
- [Usage](#usage)
- [Resources Created](#resources-created)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Example TFVARS](#example-tfvars)
- [Notes](#notes)

## Prerequisites

- AWS account with proper permissions for ECS, IAM, Secrets Manager, CloudWatch Logs.
- Username, password and URL of the private registry that owns the container image
- Terraform

## Usage

There is an example below of entries to place in the main.tf of the root folder of this repository, or in a .tfvars file. Also, all variables in variables.tf have a description. After filling them in, just apply
``` terraform
terraform plan -out=pl
terraform apply pl
```
### Remote Backend
- The default backend is S3, and for that you need to pass credentials in terraform init.

## Resources Created

| Resource | Description |
| --------- | --------------------------- |
| Task definition | Container Group Definitions |
| Service definition | Service definitions (platform is Fargate). I used public subnets. Changes need to be made if you use private subnets. |
| cluster definition | Definition of the cluster that will receive the service. |
| log group | Group of logs referring to the task definition |
| logstream | Stream of logs referring to the task definition |
| Secret | Credentials from your private registry. AWS requires that they be saved in a secret |
| Policy | ECS Policy |
| Scroll | ECS role, which contains the policy |


## Inputs
### Variable description and format is in variables.tf

| Variable | Description |
| ---------- | --------------------------- |
| region | Region in which the resources will be created. |
| access_key | Access key of the AWS user that will perform the actions of this repository. |
| secret_key | AWS user secret key |
| registry_credentials | Username and Access Key of your private registry. I used Gitlab. |
| app_name | Task definition name |
| container_port | Container door |
| host_port | Host Port |
| cpu | Container's CPU Units |
| memory | Container MiB memory |
| s3_env_file_arns | List of ARNs of .env files that will be passed to the container. Optional |
| registry | URL of the private registry where the container image is |
| image_version | version of the container image in the registry. Changing the image_version using terraform apply automatically redeploys |
| family | Family name |
| ecs_cluster_name | Cluster Name |
| desired_count | Qty of containers |
| subnet_ids | ids of the subnets where the containers will be deployed |
| security_group_ids | ids of the security groups in which the containers will be deployed. Need port 80/443 released in case of public subnet |

## Example TFVARS
``` terraform
registry_credentials = {
  username = "username"
  password="access_key_or_password"
}
registry="registry.gitlab.com/xxx/app/name"
family="app-family"
app_name = "app-name"
access_key="XXX"
secret_key="XXX"
image_version="0.0.1"
desired_count = 1
subnet_ids = ["subnet-XXX"]
security_group_ids = ["sg-XXX"]
ecs_cluster_name = "app-cluster"
```

## Outputs

Listing and describing the main outputs provided by the module.

| Output | Description |
| --------- | --------------------------- |
| ecs_policy | Policy attached to ECS for access to Secrets Manager and CloudWatch Logs |
| task_revision | Revision of the service that will be deployed in apply |
| container_definitions | Output from task_definitions.json. It is marked *sensitive* |


## Comments
- environment variables passed to the container can be defined in the variable **s3_env_file_arns**, such as list of ARNs of env files on your S3 and/or in a file **./modules/ecs-private/env.json** , optionally, in the form
```json
[
    {
        "name": "VAR1",
        "value": "VALUE"
    }
]
```
it is also possible not to pass any arguments.

## WIP.
- [x] ECS Private Registry and CloudWatch Logs
- [ ] CloudFront distribution + S3 frontend
- [ ] RDS / Cognito pool