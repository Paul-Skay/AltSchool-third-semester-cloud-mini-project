# Create Application Load balancer
resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public_subnet.*.id

  tags = {
    Name = "${var.project_name}-lb"
  }
}

# Create target group
resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.project_name}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.custom_vpc.id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
}

# Target Group Attachment with Instance
resource "aws_alb_target_group_attachment" "tg_attachment" {
  count            = length(aws_instance.instance.*.id) == 3 ? 3 : 0
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = element(aws_instance.instance.*.id, count.index)
}

# Listener
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}