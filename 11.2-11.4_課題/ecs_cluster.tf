resource "aws_ecs_cludter" "ecs_cluster" {
   name = "hirayama-test-ecs_cluster"
}

resource "aws_task_definition" "task_definition" {
    family = "hirayama-test"
    cpu = "256"
    memory = "512"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    container_definitions    = "${file("./container_definitions.json")}"
}

resource "aws_ecs_service" "ecs_service" {
  name                              = "hirayama-test-service"
  cluster                           = "${aws_ecs_cluster.ecs_cluster.arn}"
  task_definition                   = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.3.0"
  health_check_grace_period_seconds = 120
}

network_configuration {
    assign_public_ip = false
    security_groups  = ["${module.test_sg.security_group_id}"]

    subnets = [
      "${aws_subnet.private_subnet.id}"
    ]
}
     lifecycle {
    ignore_changes = ["task_definition"]
  }

  

