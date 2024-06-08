resource "aws_lb" "app_lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id

  tags = var.lb_tag
}

resource "aws_lb_target_group" "frontend_tg" {
  name        = var.frontend_target_group_name
  port        = var.http_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.frontend_target_group_tag
}

resource "aws_lb_target_group" "backend_tg" {
  name        = var.backend_target_group_name
  port        = var.http_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.backend_target_group_tag
}

resource "aws_lb_target_group" "metabase_tg" {
  name        = var.metabase_target_group_name
  port        = var.metabase_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.metabase_target_group_tag
}

resource "aws_lb_target_group_attachment" "frontend_attachment" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = data.aws_instances.frontend_instances.ids[0]
  port             = 80
}

resource "aws_lb_target_group_attachment" "backend_attachment" {
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = data.aws_instances.backend_instances.ids[0]
  port             = 80
}

resource "aws_lb_target_group_attachment" "metabase_attachment" {
  target_group_arn = aws_lb_target_group.metabase_tg.arn
  target_id        = data.aws_instances.metabase_instances.ids[0]
  port             = 3000
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    host_header {
      values = ["backend.azeemahmed.online"]
    }
  }
}

resource "aws_lb_listener_rule" "metabase_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase_tg.arn
  }

  condition {
    host_header {
      values = ["metabase.azeemahmed.online"]
    }
  }
}
