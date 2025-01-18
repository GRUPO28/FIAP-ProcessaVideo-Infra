resource "aws_sqs_queue" "terraform_queue" {
  name                      = "videos-queue"
  max_message_size          = 2048
  message_retention_seconds = 86400 //24h
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 300 //5min
}