provider "aws" {
  region = var.region
  #access_key = ""
  #secret_key = ""
}



module "vpc" {
  source = "./vpc"
  region = var.region
  deployment_name = var.deployment_name
  azs = var.azs
  management_vpc_cidr = var.management_vpc_cidr
  management_public_subnets_cidr = var.management_public_subnets_cidr
  app_vpc_cidr = var.app_vpc_cidr
  app_public_subnets_cidr = var.app_public_subnets_cidr
  app_private_subnets_cidr = var.app_private_subnets_cidr
}


module "s3" {
  source = "./s3"
  s3_bucket_name = var.s3_bucket_name
}


module "iam" {
  source = "./iam"
  s3_bucket_name = var.s3_bucket_name
  deployment_name = var.deployment_name
}


module "bastion" {
  source = "./bastion"
  region = var.region
  instance_type = var.instance_type
  amis = var.amis
  deployment_name = var.deployment_name
  bastion_ssh_sg_id = "${module.vpc.bastion_ssh_sg_id}"
  ssh_from_bastion_sg_id = "${module.vpc.ssh_from_bastion_sg_id}"
  key_name = var.key_name
  management_public_subnet_id = "${module.vpc.management_public_subnet_id}"
  management_public_subnets_cidr = var.management_public_subnets_cidr
  management_vpc_cidr = var.management_vpc_cidr
  app_private_subnets_cidr = var.app_private_subnets_cidr
  app_public_subnets_cidr = var.app_public_subnets_cidr
  app_vpc_cidr = var.app_vpc_cidr
}


module "ec2" {
  source = "./ec2"
  region = var.region
  instance_type = var.instance_type
  s3_bucket_name = var.s3_bucket_name
  amis = var.amis
  deployment_name = var.deployment_name
  bastion_ssh_sg_id = "${module.vpc.bastion_ssh_sg_id}"
  peer_ssh_sg_id = "${module.vpc.peer_ssh_sg_id}"
  ssh_from_bastion_sg_id = "${module.vpc.ssh_from_bastion_sg_id}"
  key_name = var.key_name
  app_public_subnets_cidr = var. app_public_subnets_cidr
  app_private_subnets_cidr = var.app_private_subnets_cidr
  app_vpc_cidr = var.app_vpc_cidr
  management_public_subnet_id = "${module.vpc.management_public_subnet_id}"
  management_public_subnets_cidr = var.management_public_subnets_cidr
  management_vpc_cidr = var.management_vpc_cidr
  app_private_subnet_id = "${module.vpc.app_private_subnet_id}"
  iam_instance_profile = "${module.iam.iam_instance_profile_name}"
}

module "cloudwatch" {
  source = "./cloudwatch"
  region = var.region
  deployment_name = var.deployment_name
  aws_instance_id = "${module.ec2.aws_instance_id}"
}


