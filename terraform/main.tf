resource "aws_dynamodb_table" "video-dynamodb-table" {
  name           = "Video"
  billing_mode   = "PROVISIONED"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "Id_Video"

  attribute {
    name = "Id_Video"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
}


resource "aws_dynamodb_table" "usuario-dynamodb-table" {
  name           = "Usuario"
  billing_mode   = "PROVISIONED"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "Id_Usuario"

  attribute {
    name = "Id_Usuario"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
}