

variable "region" {}
variable "instance_type" {}
variable "amis" {}
variable "ip_range" {}
variable "s3_bucket_name" {}
variable "key_name" {}
variable "existing_vpc_id" {}
variable "deployment_name" {}
variable "management_vpc_cidr" {}
variable "management_public_subnets_cidr" {}
variable "app_vpc_cidr" {}
variable "app_public_subnets_cidr" { type = list }
variable "app_private_subnets_cidr" { type = list }
variable "azs" { type = list }

