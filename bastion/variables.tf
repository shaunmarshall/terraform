

variable "region" {}
variable "instance_type" {}
variable "amis" {}
variable "management_public_subnet_id" {}
variable "key_name" {}
variable "deployment_name" {}
variable "management_vpc_cidr" {}
variable "management_public_subnets_cidr" {}
variable "app_vpc_cidr" {}
variable "app_public_subnets_cidr" { type = list }
variable "app_private_subnets_cidr" { type = list }
variable "bastion_ssh_sg_id" {}
variable "ssh_from_bastion_sg_id" {}


#variable "azs" { type = list }






