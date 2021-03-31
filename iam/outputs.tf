output "iam_instance_profile_name" {
	value = "${aws_iam_role.ec2_role.name}"
}