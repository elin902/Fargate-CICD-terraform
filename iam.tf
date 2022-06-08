#codebuild 

resource "aws_iam_role" "codebuild-test-role" {
  name               = var.name
  assume_role_policy = file("policy/codebuild-role.json")
}

resource "aws_iam_role_policy" "codebuild-test-policy" {
  role   = aws_iam_role.codebuild-test-role.name
  policy = file("policy/codebuild-policy.json")
}

#ecs

resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role"
  assume_role_policy = file("policy/ecs-task-role.json")
}

resource "aws_iam_role_policy" "ecs-task-execution-policy" {
  name   = "ecs-task-execution-policy"
  role   = aws_iam_role.ecs_task_role.name
  policy = file("policy/ecs-task-execution-policy.json")
}

resource "aws_iam_role" "codepipeline_role" {
  name = "pipeline-role"

  assume_role_policy = file("policy/codepipeline-role.json")
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = file("policy/codepipeline-policy.json")
}

resource "aws_iam_policy_attachment" "pipeline-policy-attachment" {
  name       = "pipeline-policy-attachment"
  roles      = [aws_iam_role.codepipeline_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}