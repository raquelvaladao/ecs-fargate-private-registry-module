# Backend no ECS/Fargate com Private Registry e logs no CloudWatch

Este é um módulo para subir um service de ECS-Fargate funcional e rodando no ECS a partir de uma imagem de um registry privado, com a configuração adequada de logs no CloudWatch Logs do container.

Meu caso de uso é o Gitlab Private Registry, mas voce pode usar o username, password e URL do seu provedor.

Fiz esse projeto para automatizar a criação de um side-project pessoal meu em Java, containerizado, feito completamente na AWS. Nesse ponto, há aqui nesse repo apenas a parte de backend, mas pretendo estendê-la  para o resto da infra no futuro.

## Sumário
- [Pré-requisitos](#pré-requisitos)
- [Uso](#uso)
- [Recursos Criados](#Recursos-Criados)
- [Inputs](#Inputs)
- [Outputs](#Outputs)
- [Exemplo TFVARS](#Exemplo-TFVARS)
- [Observações](#Observações)

## Pré-requisitos

- Conta na AWS com as permissões adequadas para ECS, IAM, Secrets Manager, CloudWatch Logs.
- Username, password e URL do registry privado que possui a imagem do container
- Terraform

## Uso

Há um exemplo abaixo de inputs a se colocar no main.tf da pasta raíz desse repositório, ou em um arquivo .tfvars. Além disso, todas as variáveis de variables.tf possuem descrição. Depois que preenchê-las, é só aplicar
```terraform
terraform plan -out=pl
terraform apply pl
```

## Recursos Criados

| Recurso   | Descrição                   |
| --------- | --------------------------- |
| Task definition | Definições do grupo de containers      |
| Service definition | Definições de service (a plataforma é Fargate). Eu usei subnets públicas. É preciso fazer alterações caso você use subnets privadas.      |
| Cluster definition | Definição do cluster que receberá a service.      |
| Log group | Grupo de logs referente à task definition     |
| Log stream | Stream de logs referente à task definition     |
| Secret | Credenciais do seu registry privado. A AWS obriga que sejam salvas em um secret      |
| Policy | Policy do ECS      |
| Role | Role do ECS, que contém a policy      |

## Inputs
### A descrição e formato das variáveis está em variables.tf

| Variável   | Descrição                   |
| ---------- | --------------------------- |
| access_key | Access key do user AWS que irá performar as ações desse repositório.     |
| secret_key | Secret key do user AWS     |
| gitlab_credentials | Username e Access Key do seu registry privado. eu usei o Gitlab.     |
| app_name | Nome da task definition     |
| registry | URL do registry privado em que está a imagem do container     |
| image_version | version da imagem do container no registry. A mudança de image_version com o uso de terraform apply já faz o redeploy automaticamente     |
| family | Nome da family     |
| ecs_cluster_name | Nome do cluster     |
| desired_count | Qtd de containers     |
| subnet_ids | ids das subnets em que os containers serão deployados     |
| security_group_ids | ids dos security groups em que os containers serão deployados. Precisam da porta 80/443 liberadas no caso de subnet pública     |
 
## Exemplo TFVARS
```terraform
gitlab_credentials = {
  username = "username"
  password = "access_key_ou_password"
}
registry = "registry.gitlab.com/xxx/app/name"
family = "app-family"
app_name = "app-name"
access_key = "XXX"
secret_key = "XXX"
image_version = "0.0.1"
desired_count = 1
subnet_ids = ["subnet-XXX"]
security_group_ids = ["sg-XXX"]
ecs_cluster_name = "app-cluster"
```

## Outputs

Liste e descreva as principais saídas fornecidas pelo módulo Terraform.

| Saída     | Descrição                   |
| --------- | --------------------------- |
| ecs_policy   | Policy atachada no ECS para acesso ao Secrets Manager e CloudWatch Logs      |
| task_revision  | Revision do service que será deployado no apply        |


## Observações
- variáveis de ambiente passadas pra o container precisam ser definidas em um arquivo env.json (por enquanto é obrigatório), na forma
```json
[
    {
        "name": "VAR1",
        "value": "VALUE"
    }
]
```

## WIP.
- [ ] Tornar env.json opcional
- [ ] Mover region para variables