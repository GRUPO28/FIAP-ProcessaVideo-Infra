output "dynamodb_table_video_name" {
  value = aws_dynamodb_table.video-dynamodb-table.name
}

output "dynamodb_table_usuario_name" {
  value = aws_dynamodb_table.usuario-dynamodb-table.name
}