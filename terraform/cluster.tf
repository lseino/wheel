resource "aws_ecs_cluster" "my_cluster" {
  name = "app-cluster" # Naming the cluster
}

resource "aws_ecs_task_definition" "nginx-app" {
  family                   = "nginx-app" 
  container_definitions    = <<TASK_DEFINITION
  [
    {
      "name": "nginx-app",
      "image": "nginx",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  TASK_DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_ecs_service" "app-service" {
  name            = "app-service"                             # Naming our first service
  cluster         = aws_ecs_cluster.my_cluster.id             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.nginx-app.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers to 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.nginx-app.family
    container_port   = 80 # Specifying the container port
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = [aws_security_group.service_security_group.id] # Setting the security group
  }
}