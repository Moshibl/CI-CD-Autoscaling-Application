resource "aws_launch_template" "LaunchTMP" {
  name                   = var.LaunchTMP_Name
  image_id               = var.AMI
  instance_type          = var.Instance_Type
  key_name               = var.Key_Name
  vpc_security_group_ids = var.Security_Group_Ids
  user_data              = var.UserData
}

resource "aws_autoscaling_group" "AutoScalingGroup" {
  name                      = var.ASG_Name
  desired_capacity          = var.Desired_Capacity
  min_size                  = var.Min_Size
  max_size                  = var.Max_Size
  vpc_zone_identifier       = var.VPC_Zone_Id
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = var.TG_Arns

  launch_template {
    id      = aws_launch_template.LaunchTMP.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = var.ASG_Instance_Name
    propagate_at_launch = true
  }
  tag {
    key                 = "Role"
    value               = var.ASG_Instance_Role
    propagate_at_launch = true
  }
}

data "aws_instances" "ASG_Instances" {
  instance_tags = {
    Role = var.ASG_Instance_Role
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}