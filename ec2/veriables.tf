

variable "region" {}
variable "instance_type" {}
variable "s3_bucket_name" {}
variable "amis" {}
variable "key_name" {}
#variable "ssh_Private_key_Path" {}
variable "deployment_name" {}
variable "management_public_subnet_id" {}
variable "app_private_subnet_id" {}
variable "peer_ssh_sg_id" {}
variable "bastion_ssh_sg_id" {}
variable "ssh_from_bastion_sg_id" {}
variable "iam_instance_profile" {}
variable "management_vpc_cidr" {}
variable "management_public_subnets_cidr" { }
variable "app_vpc_cidr" {}
variable "app_public_subnets_cidr" { type = list }
variable "app_private_subnets_cidr" {}

#variable "azs" { type = list }





