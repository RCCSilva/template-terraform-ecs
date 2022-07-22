resource "aws_ecs_cluster" "main" {
  name = "production-ecs"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
