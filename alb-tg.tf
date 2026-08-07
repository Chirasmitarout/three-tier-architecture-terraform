resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}
resource "aws_lb" "alb" {

  name               = "three-tier-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  tags = {
    Name = "Three-Tier-ALB"
  }
}

resource "aws_lb_target_group" "frontend" {

  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {
    path = "/"

    protocol = "HTTP"
    port     = "traffic-port"
  }

  tags = {
    Name = "Frontend-TG"
  }
}

resource "aws_lb_target_group" "backend" {

  name     = "backend-tg"
  port     = 5000
  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {
    path = "/"

    protocol = "HTTP"
    port     = "traffic-port"
  }

  tags = {
    Name = "Backend-TG"
  }
}

resource "aws_lb_target_group_attachment" "frontend" {

  target_group_arn = aws_lb_target_group.frontend.arn

  target_id = aws_instance.public.id

  port = 80
}

resource "aws_lb_target_group_attachment" "backend1" {

  target_group_arn = aws_lb_target_group.backend.arn

  target_id = aws_instance.private[0].id

  port = 5000
}

resource "aws_lb_target_group_attachment" "backend2" {

  target_group_arn = aws_lb_target_group.backend.arn

  target_id = aws_instance.private[1].id

  port = 5000
}
resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener_rule" "backend" {

  listener_arn = aws_lb_listener.http.arn

  priority = 100

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {

    path_pattern {

      values = ["/api/*"]
    }
  }
}