#  Hackathon - Provisionamento infraestrutura

Este projeto utiliza o Terraform para provisionar o DynamoDB na AWS, user pool e o sqs para o projeto processa vídeo.

## Importante
Lembrese de criar um usuário e fazer login no cognito pois o token será usado para acessar a API.

## Para mais informações sobre o projeto:
[Processa Vídeo - API](https://github.com/GRUPO28/FIAP-ProcessaVideo-API)


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