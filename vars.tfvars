
region = "us-west-2"
s3_bucket_name = "sm-sbox-phrasee"
ec2_iam_role_name = "sm-sbox-ec2-aim-role"
ssh_Private_key_Path = "~/.ssh//sm-us-west-2.pem"
key_name = "sm-us-west-2"
ip_range = "0.0.0.0/0"
instance_type = "t2.micro"
deployment_name = "sm-terraform-test"
management_vpc_cidr = "10.1.0.0/16"
management_public_subnets_cidr = "10.1.10.0/24"
app_vpc_cidr = "10.2.0.0/16"
app_public_subnets_cidr = ["10.2.1.0/24","10.2.2.0/24"]
app_private_subnets_cidr = ["10.2.10.0/24","10.2.11.0/24"]
existing_vpc_id = ""
azs  = ["us-west-2a","us-west-2b"]
amis = {
    us-west-1 = "ami-017b2c64d333ddbf6"
    us-west-2 = "ami-07dd19a7900a1f049"
  }





