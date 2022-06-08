resource "aws_codestarconnections_connection" "github-cs-connection" {
  name          = "CodeStar connection to github"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      input_artifacts  = []
      output_artifacts = ["source_artifact"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github-cs-connection.arn
        FullRepositoryId = var.repository_url
        BranchName       = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_artifact"]
      output_artifacts = ["build_artifact"]
      version          = "1"
      configuration = {
        ProjectName = "codebuild-${var.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      input_artifacts  = ["build_artifact"]
      output_artifacts = []
      version          = "1"
      configuration = {
        ClusterName = aws_ecs_cluster.cluster.name
        ServiceName = aws_ecs_service.ecs-service.name
      }
    }
  }
}