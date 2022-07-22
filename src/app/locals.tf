locals {
  db_port   = 5432
  db_engine = "postgresql"
  db_user   = "${replace(var.name, "-", "_")}_user"
  db_name   = replace(var.name, "-", "_")

  container_name = "app-container"
  container_port = 3000
}
