module "app_1" {
  source = "./app"

  name        = "template-app-ecs"
  github_repo = "rccsilva/template-app-ecs"

  public_subnets    = aws_subnet.public
  private_subnets   = aws_subnet.private
  vpc               = aws_vpc.main
  ecs_cluster       = aws_ecs_cluster.main
  load_balancer     = aws_lb.main
  github_connection = aws_codestarconnections_connection.main
  listener_main     = aws_lb_listener.main
  listener_test     = aws_lb_listener.test
}

module "app_2" {
  source = "./app"

  name        = "another-template"
  github_repo = "rccsilva/template-app-ecs"

  public_subnets    = aws_subnet.public
  private_subnets   = aws_subnet.private
  vpc               = aws_vpc.main
  ecs_cluster       = aws_ecs_cluster.main
  load_balancer     = aws_lb.main
  github_connection = aws_codestarconnections_connection.main
  listener_main     = aws_lb_listener.main
  listener_test     = aws_lb_listener.test
}

module "app_3" {
  source = "./app"

  name        = "users-lambda3"
  github_repo = "rccsilva/template-app-ecs"

  public_subnets    = aws_subnet.public
  private_subnets   = aws_subnet.private
  vpc               = aws_vpc.main
  ecs_cluster       = aws_ecs_cluster.main
  load_balancer     = aws_lb.main
  github_connection = aws_codestarconnections_connection.main
  listener_main     = aws_lb_listener.main
  listener_test     = aws_lb_listener.test
}
