terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # Exemplo de versão, com base em sua necessidade
    }
  }

  backend "s3" {
    bucket = "github-pipe"
    key    = "hackathon-infra-db/terraform.tfstate"
    region = "sa-east-1"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "Infra dynamodb para projeto processa vídeo"
      Owner   = "Grupo 28"
    }
  }
}
