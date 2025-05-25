resource "aws_lb" "ALB" {
  name               = var.LB_Name
  internal           = var.Is_Internal
  load_balancer_type = "application"
  security_groups    = var.Security_Group_Id
  subnets            = var.Subnet_Ids
  tags               = { Deployment = "Terraform" }
}

resource "aws_lb_listener" "LB_Listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LB_TG.arn
  }
}

resource "aws_lb_target_group" "LB_TG" {
  name        = var.TargetGroupName
  vpc_id      = var.VPC_ID
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
}