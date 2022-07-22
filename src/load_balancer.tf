resource "aws_lb" "main" {
  name               = "main-lb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.lb.id]

  internal                   = false
  enable_deletion_protection = false
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn

  port     = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      status_code  = 404
      message_body = "{\"message\": \"not found\"}"
    }
  }
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.main.arn

  port     = "8080"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      status_code  = 404
      message_body = "{\"message\": \"not found\"}"
    }
  }
}


resource "aws_security_group" "lb" {
  name        = "main-lb-sg"
  description = "Load balancer security group"
  vpc_id      = aws_vpc.main.id

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
