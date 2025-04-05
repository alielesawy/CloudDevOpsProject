# modules/ec2/main.tf
resource "aws_instance" "app" {
  count                   = var.instance_count
  ami                     = "ami-084568db4383264d4"  # Ubuntu AMI (us-east-1)
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  key_name                = var.key_name
  vpc_security_group_ids  = [var.security_group_id]
  associate_public_ip_address = true  # Explicitly assign public IP
  
  tags = {
    Name = "app-instance-${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  count               = var.instance_count
  alarm_name          = "cpu-utilization-${count.index + 1}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  
  dimensions = {
    InstanceId = aws_instance.app[count.index].id
  }
  
  alarm_actions = []
}