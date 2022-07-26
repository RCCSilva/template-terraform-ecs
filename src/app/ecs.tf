resource "aws_cloudwatch_log_group" "ecs_service" {
  name = "/ecs/${var.name}"
}

resource "aws_ecs_task_definition" "main" {
  family             = "${var.name}-td"
  cpu                = 256
  memory             = 512
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "rccsilva/dummy-server"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = local.container_port
          hostPort      = local.container_port
        }
      ]
    }
  ])

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "service" {
  name            = "${var.name}-sc"
  cluster         = var.ecs_cluster.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = local.container_name
    container_port   = local.container_port
  }

  network_configuration {
    subnets         = var.private_subnets.*.id
    security_groups = [aws_security_group.task_sg.id]
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }
}

resource "aws_security_group" "task_sg" {
  name        = "${var.name}-task-sg"
  description = "${var.name} task instance security group"
  vpc_id      = var.vpc.id

  ingress = [
    {
      description      = "Allow ingress requests from the VPC"
      from_port        = local.container_port
      to_port          = local.container_port
      protocol         = "tcp"
      cidr_blocks      = [var.vpc.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all egress internet traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}
