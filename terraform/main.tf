resource "aws_dynamodb_table" "video-dynamodb-table" {
  name           = "Video-DynamoDB-Table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "Id"
  range_key      = "Id_Usuario"

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

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  # Índice Secundário Global (GSI) para Url
  global_secondary_index {
    name            = "UrlIndex"
    hash_key        = "Url"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }

  # Índice Secundário Global (GSI) para Status
  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "Status"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }
}


resource "aws_dynamodb_table" "usuario-dynamodb-table" {
  name           = "Usuario-DynamoDB-Table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "Id_Usuario"

  attribute {
    name = "Id_Usuario"
    type = "S"
  }

  attribute {
    name = "Password"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  # Índice Secundário Global (GSI) para email
  global_secondary_index {
    name            = "EmailIndex"
    hash_key        = "email"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }

  # Índice Secundário Global (GSI) para Password
  global_secondary_index {
    name            = "PasswordIndex"
    hash_key        = "Password"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }
}