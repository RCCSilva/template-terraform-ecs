resource "aws_codestarconnections_connection" "main" {
  name          = "main-github-connection"
  provider_type = "GitHub"
}
