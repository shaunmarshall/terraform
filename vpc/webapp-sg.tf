resource "aws_security_group" "peer_ssh_sg" {
  depends_on = ["aws_vpc.app_vpc"]
  vpc_id = aws_vpc.app_vpc.id
  name = "peer_ssh"
  description = "Allow SSH to web app host from approved ranges"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "${var.deployment_name}_peer_ssh"
  }
}