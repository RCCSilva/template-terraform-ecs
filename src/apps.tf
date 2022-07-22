module "app_main" {
  source = "./app"

  name = "template-app-ecs"

  public_subnets     = aws_subnet.public
  private_subnets    = aws_subnet.private
  vpc                = aws_vpc.main
  ecs_cluster        = aws_ecs_cluster.main
  load_balancer      = aws_lb.main
  github_connection  = aws_codestarconnections_connection.main
  listener_main      = aws_lb_listener.main
  listener_test      = aws_lb_listener.test
}
