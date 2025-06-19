data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}


resource "aws_launch_template" "app_lt" {
  name_prefix   = "todo-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = var.key_pair_name

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh.tpl", {
      db_host = aws_db_instance.todo_db.address,
      db_user = var.db_username,
      db_pass = var.db_password,
      db_name = aws_db_instance.todo_db.db_name
    })
  )

  vpc_security_group_ids = [aws_security_group.app_sg.id]
}

resource "aws_autoscaling_group" "app_asg" {
  name              = "todo-asg"
  desired_capacity  = 1
  min_size          = 1
  max_size          = 2
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = aws_subnet.public[*].id
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "todo-app"
    propagate_at_launch = true
  }
}
