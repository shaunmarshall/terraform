data "template_file" "ec2_userdata_script" {
  template = file("${path.module}/../userdata/setup-ec2-userdata.sh")

  vars = {
    region            = var.region
    s3_bucket_name    = var.s3_bucket_name
    deployment_name   = var.deployment_name
  }
}

# ec2 Instance
resource "aws_instance" "web1" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  tags = {
    Name = "${var.deployment_name}_web1"
  }
  subnet_id = var.management_public_subnet_id
  #subnet_id = var.app_private_subnet_id
  associate_public_ip_address = true
  #vpc_security_group_ids = ["${var.peer_ssh_sg_id}"]
  vpc_security_group_ids = ["${var.bastion_ssh_sg_id}","${var.ssh_from_bastion_sg_id}"]
  key_name = "${var.key_name}"
  iam_instance_profile = var.iam_instance_profile
  user_data_base64  = base64encode(data.template_file.ec2_userdata_script.rendered)
}

resource "aws_eip" "web1" {
  instance = "${aws_instance.web1.id}"
  vpc = true
}
