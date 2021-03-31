
# Bastion Instance
resource "aws_instance" "bastion" {
  #count = "${length(var.management_public_subnets_cidr)}"
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  tags = {
    Name = "${var.deployment_name}_bastion"
  }
  subnet_id = var.management_public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = ["${var.bastion_ssh_sg_id}","${var.ssh_from_bastion_sg_id}"]
  key_name = "${var.key_name}"
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}

