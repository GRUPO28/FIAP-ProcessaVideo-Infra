data "aws_vpc" "default-vpc" {
  filter {
    name   = "tag:Name"
    values = ["default-us-east-1"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default-vpc.id]
  }
}