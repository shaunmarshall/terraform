output "management_vpc_id" {
	value = "${aws_vpc.management_vpc.id}"
}

output "app_vpc_id" {
	value = "${aws_vpc.app_vpc.id}"
}

output "management_public_subnet_id" {
	value = "${aws_subnet.management_public.id}"
}

output "app_public_subnet_0_id" {
	value = "${aws_subnet.app_public[0].id}"
}

output "app_public_subnet_1_id" {
	value = "${aws_subnet.app_public[1].id}"
}

output "app_private_subnet_id" {
	value = "${aws_subnet.app_private[0].id}"
}

output "ssh_from_bastion_sg_id" {
  value = "${aws_security_group.ssh_from_bastion_sg.id}"
}

output "bastion_ssh_sg_id" {
  value = "${aws_security_group.bastion_ssh_sg.id}"
}

output "peer_ssh_sg_id" {
	value = "${aws_security_group.peer_ssh_sg.id}"
}

