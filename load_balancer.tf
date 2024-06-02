resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = aws_subnet.private_subnet[*].id 

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    protocol            = "HTTP"
    port                = 80
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    protocol            = "HTTP"
    port                = 80
  }
}

resource "aws_lb_listener_rule" "frontend_rule" {
    listener_arn = aws_lb_listener.app_listener.arn

    action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
  condition {
      host_header {
        values = ["frontend.example.com"]
      }
    }
}

resource "aws_lb_listener_rule" "backend_rule" {
    listener_arn = aws_lb_listener.app_listener.arn

    action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
  condition {
      host_header {
        values = ["backend.example.com"]
      }
    }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Unsupported path"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group_attachment" "frontend_attachment" {
    depends_on = [ aws_instance.ec2_instance_private ]
  target_group_arn  = aws_lb_target_group.frontend_tg.arn
  target_id         = element(aws_instance.ec2_instance_private.*.id, index(var.ec2_instance_names, "frontend"))
  port              = 80
}

resource "aws_lb_target_group_attachment" "backend_attachment" {
    depends_on = [ aws_instance.ec2_instance_private ]
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id = element(aws_instance.ec2_instance_private.*.id, index(var.ec2_instance_names, "backend"))
  port = 80
}