data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_ecs_cluster" "processa_video_cluster" {
  name = "processa-video-cluster"
}

resource "aws_ecs_task_definition" "processa_video_task" {
  family                   = "processa-video-task"
  container_definitions    = <<DEFINITION
  [
    {
    "environment": [
        {
          "name": "AWS__Region",
          "value": "${var.AWS_REGION}"
        },
        {
          "name": "AWS__AccessKeyId",
          "value": "${var.AWS_ACCESS_KEY_ID}"
        },
        {
          "name": "AWS__SecretAccessKey",
          "value": "${var.AWS_SECRET_ACCESS_KEY}"
        },
        {
          "name": "AWS__Cognito__UserPoolId",
          "value": "${module.cognito_user_pool.id}"
        },
        {
          "name": "AWS__Cognito__IdentityPoolId",
          "value": "us-east-1:5df51be0-85fa-4bda-ad9c-73b4114d1929"
        },
        {
          "name": "AWS__Cognito__AppClientId",
          "value": "${aws_cognito_user_pool_client.userpool_client.id}"
        },
        {
          "name": "AWSS3__BucketName",
          "value": "${var.APP_BUCKET_NAME}"
        },
        {
          "name": "SQS__QueueUrl",
          "value": "${aws_sqs_queue.terraform_queue.url}"
        },
        {
          "name": "Database__TableName",
          "value": "Video"
        }
      ],
      "name": "processa-video-task",
      "image": "grupo28/videoapi",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5158,
          "hostPort": 5158
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-create-group": "true",
              "awslogs-group": "awslogs-processa-video-api",
              "awslogs-region": "us-east-1",
              "awslogs-stream-prefix": "awslogs-processa-video"
          }
      },
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "processa-video-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_alb" "application_load_balancer" {
  name               = "processa-video-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.subnets.ids
  security_groups    = ["${aws_security_group.load_balancer_security_group.id}"]
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "processa-video-tg"
  port        = 5158
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default-vpc.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_ecs_service" "processa_video_service" {
  name            = "processa-video-service"
  cluster         = aws_ecs_cluster.processa_video_cluster.id
  task_definition = aws_ecs_task_definition.processa_video_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.processa_video_task.family
    container_port   = 5158
  }

  network_configuration {
    subnets          = data.aws_subnets.subnets.ids
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
