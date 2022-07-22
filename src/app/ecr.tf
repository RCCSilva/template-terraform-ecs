resource "aws_ecr_repository" "main" {
  name                 = "${var.name}-ecr"
  image_tag_mutability = "IMMUTABLE"
}
