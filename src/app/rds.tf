resource "aws_db_instance" "main" {
  identifier = "${var.name}-db"

  storage_type          = "gp2"
  allocated_storage     = 50
  max_allocated_storage = 1000

  engine         = "postgres"
  engine_version = "13"
  instance_class = "db.t3.micro"

  db_name  = local.db_name
  username = local.db_user
  password = random_password.db.result
  port     = local.db_port

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [
    aws_security_group.db.id
  ]

  final_snapshot_identifier = "${var.name}-db-final-snapshot"
  skip_final_snapshot = false
  publicly_accessible = false
}

resource "random_password" "db" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.name}-subnet-db"
  subnet_ids = var.private_subnets.*.id
}


resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "${var.name} database security group"
  vpc_id      = var.vpc.id

  ingress = [
    {
      description      = "Allo ingress from the VPC"
      from_port        = local.db_port
      to_port          = local.db_port
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
      description      = "Allow egress all internet traffic"
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

