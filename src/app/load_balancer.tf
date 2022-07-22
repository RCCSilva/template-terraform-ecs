resource "aws_lb_target_group" "blue" {
  name        = "${var.name}-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc.id

  health_check {
    path = "/${var.name}/health"
    port = local.container_port
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "green" {
  name        = "${var.name}-green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc.id

  health_check {
    path = "/${var.name}/health"
    port = local.container_port
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = var.listener_main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    path_pattern {
      values = ["/${var.name}/*"]
    }
  }
}

resource "aws_lb_listener_rule" "test" {
  listener_arn = var.listener_test.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    path_pattern {
      values = ["/${var.name}/*"]
    }
  }
}

resource "aws_security_group" "lb" {
  name        = "${var.name}-lb-sg"
  description = "${var.name} load balancer security group"
  vpc_id      = var.vpc.id

  ingress = [
    {
      description      = "Allow ingress HTTP requests from the internet"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
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
