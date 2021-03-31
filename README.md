## Deployment Prereqs

update vars.tfvars with dynamic varaibles

Create SSH key pair for selected region

terraform init
terraform plan --var-file=./vars.tfvar
terraform apply --auto-approve --var-file=./vars.tfvar

** Tested in region us-west-2

