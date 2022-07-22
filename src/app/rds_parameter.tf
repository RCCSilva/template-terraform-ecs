resource "aws_ssm_parameter" "name" {
  name        = "/${var.name}/DB_NAME"
  description = "\"${var.name}\" database name."
  type        = "String"
  value       = aws_db_instance.main.name
}

resource "aws_ssm_parameter" "host" {
  name        = "/${var.name}/DB_HOST"
  description = "\"${var.name}\" database host."
  type        = "SecureString"
  value       = split(":", aws_db_instance.main.endpoint)[0]
}

resource "aws_ssm_parameter" "user" {
  name        = "/${var.name}/DB_USER"
  description = "\"${var.name}\" database user."
  type        = "SecureString"
  value       = aws_db_instance.main.username
}

resource "aws_ssm_parameter" "password" {
  name        = "/${var.name}/DB_PASS"
  description = "\"${var.name}\" database password."
  type        = "SecureString"
  value       = aws_db_instance.main.password
}

resource "aws_ssm_parameter" "port" {
  name        = "/${var.name}/DB_PORT"
  description = "\"${var.name}\" database port."
  type        = "String"
  value       = local.db_port
}
