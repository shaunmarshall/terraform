resource "aws_security_group" "bastion_ssh_sg" {
  depends_on = ["aws_vpc.management_vpc"]
  vpc_id = aws_vpc.management_vpc.id
  name = "bastion_ssh"
  description = "Allow SSH to Bastion host from approved ranges"
  
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
      Name = "${var.deployment_name}_bastion_ssh"
  }
}

resource "aws_security_group" "ssh_from_bastion_sg" {
  depends_on = ["aws_vpc.management_vpc"]
  name = "ssh_from_bastion"
  description = "Allow SSH from Bastion host(s)"
  vpc_id = aws_vpc.management_vpc.id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.bastion_ssh_sg.id}",
    ]
  }

  tags = {
      Name = "${var.deployment_name}_ssh_from_bastion"
  }
}

