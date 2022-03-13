resource "aws_launch_configuration" "test" {
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance-type
  security_groups = [aws_security_group.default.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install -y busybox
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF   
  lifecycle {
    create_before_destroy = true
  }
}


data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.master.id]
  }

  tags = {
    Tier = "Public"
  }
}

resource "aws_autoscaling_group" "test" {
  launch_configuration = aws_launch_configuration.test.name
  vpc_zone_identifier  = data.aws_subnets.public.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 3
  max_size = 10
  tag {
    key                 = "Name"
    value               = "asg test"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "test-asg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.master.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb" "test" {
  name               = "test-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids
  security_groups    = [aws_security_group.default.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}
