resource "aws_dynamodb_table" "video-dynamodb-table" {
  name           = "Video-DynamoDB-Table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "Id"
  range_key      = "Id_Usuario"

  # Definindo os atributos da tabela
  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Id_Usuario"
    type = "S"
  }

  attribute {
    name = "Url"
    type = "S"
  }

  attribute {
    name = "Status"
    type = "S"
  }

  # Definindo TTL
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
}


resource "aws_dynamodb_table" "usuario-dynamodb-table" {
  name           = "Usuario-DynamoDB-Table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "Id_Usuario"

  # Definindo os atributos da tabela

  attribute {
    name = "Id_Usuario"
    type = "S"
  }

  attribute {
    name = "Password"
    type = "S"
  }

  # Definindo TTL
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
}