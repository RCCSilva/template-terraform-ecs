# Template Terraform ECS

ECS is the container orchestration service provided by AWS. Configuring it manually can get a little trick. This repository provides a template for Terraform which may be modified according to your needs.

## Is it production ready?

Well, I tried my best to set it production ready. Nevertheless, use at your own discretion. You're the one responsible for the resources created in AWS using this template. If you find any security issue, please create an issue describing it and consider opening a PR with the fix.

## Contributing

I highly encourage you to contribute. If you have some crazy idea and would to like to contribute, please open an issue and we'll discuss the next steps.

## Services Created

- ECS
  + ECS Cluster
  + ECS Task Definition
  + ECS Service
- ECR
- Load Balancer
- Network
  + VPC
  + Subnet
  + Elastic IP
  + NAT Gateway
  + Route tables
- RDS
- Cloudwatch Logs