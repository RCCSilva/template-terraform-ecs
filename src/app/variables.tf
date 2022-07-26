variable "name" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    id = string
  }))
}

variable "private_subnets" {
  type = list(object({
    id = string
  }))
}

variable "vpc" {
  type = object({
    id         = string
    cidr_block = string
  })
}

variable "ecs_cluster" {
  type = object({
    id   = string
    arn  = string
    name = string
  })
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "load_balancer" {
  type = object({
    arn = string
  })
}

variable "github_connection" {
  type = object({
    arn = string
  })
}

variable "listener_main" {
  type = object({
    arn = string
  })
}

variable "listener_test" {
  type = object({
    arn = string
  })
}
