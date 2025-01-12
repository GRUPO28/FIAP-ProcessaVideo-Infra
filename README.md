#  Hackathon - Provisionamento infra db

Este projeto utiliza o Terraform para provisionar o DynamoDB na AWS.

## DynamoDB
Aqui ficaram armazenados duas tabelas:
- **users**: Dados do usuário
  - id_Usuario
  - password
  - email
- **video**: Dados do processamento do vídeo
  - id
  - url
  - id_Usuario
  - status

## Passos para provisionar a infra manualmente:
- Adicionar as credenciais de acesso em `~/.aws/credentials`
- Inicialize o Terraform:
  ```bash
  terraform init
  ```
- Planeje a infraestrutura:
  ```bash
  terraform plan
  ```
- Aplique o plano:
  ```bash
  terraform apply
    ```