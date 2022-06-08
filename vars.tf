variable "name" {
  default = "learnify"
}

variable "aws_region" {
  default = "eu-west-1"
}

#network

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# logs

variable "log_retention_in_days" {
  default = 30
}

# key pair

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

#health check

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/ping/"
}

output "alb_dns_hostname" {
  value = aws_alb.alb.dns_name
}

variable "repository_url" {
  default = "elin902/codebuild-test"
}

variable "branch" {
  default = "master"
}

#ecs

variable "desired_count" {
  description = "Desired ECS tasks to run in cluster"
  default     = 4
}

variable "min_healthy_percent" {
  description = "Minimum healthy percent"
  default     = 50
}

variable "deploy_max_percent" {
  description = "Deployment maximum percent"
  default     = 200
}

variable "cpu" {
  description = "fargate CPU"
  default     = 256
}

variable "memory" {
  description = "fargate memory"
  default     = 512
}

variable "container_port" {
  description = "Container port"
  default     = 8000
}

#github

variable "github_repo" {
  description = "GitHub repo URL"
  default     = "https://github.com/elin902/codebuild-test.git"
}

#ecr

variable "ecr_repo_name" {
  description = "AWS ECR repo name"
  default     = "learnify"
}