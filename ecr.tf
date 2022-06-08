data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "ecr_token" {}

resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
}

