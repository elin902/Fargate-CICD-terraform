resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "container-template" {
  template = file("templates/container-image.json")

  vars = {
    app_name         = var.name
    docker_image_url = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
    app_port         = 8000
    region           = var.aws_region
  }
}

resource "aws_ecs_task_definition" "task-definition" {
  family                   = "learnify"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.container-template.rendered
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "ecs-service" {
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.cluster.id
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.min_healthy_percent
  deployment_maximum_percent         = var.deploy_max_percent
  task_definition                    = aws_ecs_task_definition.task-definition.arn
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs-sg.id]
    subnets          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}