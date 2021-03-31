variable "region" {}
variable "deployment_name" {}
variable "management_vpc_cidr" {}
variable "management_public_subnets_cidr" {}
variable "app_vpc_cidr" {}
variable "app_public_subnets_cidr" { type = list }
variable "app_private_subnets_cidr" {}
variable "azs" { type = list }


