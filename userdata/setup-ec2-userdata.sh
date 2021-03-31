#!/bin/bash

# log to file
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
 
# update and install required applications
sudo apt-get update
sudo apt install awscli python2 docker.io docker-compose jq pass -y
# add Ubuntu user to docker group
sudo usermod -aG docker ubuntu


#create directory for nginx volume mapping
sudo mkdir -p /containets/nginx

#copy index file from s3
aws s3 cp s3://${s3_bucket_name}/index.html /containets/nginx/

# download and install cloudwatch log agent
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py

# create log agent config
echo "
[general]
state_file = /var/awslogs/state/agent-state
 
[/var/log/*]
file = /var/log/*
log_group_name = ${deployment_name}-ec2-logs
log_stream_name = ${deployment_name}-instance
datetime_format = %b %d %H:%M:%S

[/var/llb/docker/containers/*]
file = /var/lib/docker/containers/*/*.log
log_group_name = ${deployment_name}-ec2-logs
log_stream_name = ${deployment_name}-nginx
datetime_format = %b %d %H:%M:%S
" > ./log-agent.config

# set up aws log agent
python2 ./awslogs-agent-setup.py -n -r ${region} -c ./log-agent.config

#enable and start servcies
sudo systemctl enable awslogs.service
sudo systemctl start awslogs.service
sudo systemctl enable docker
sudo systemctl start docker



#start docker container
docker run --name phrasee-nginx \
-v /containets/nginx:/usr/share/nginx/html:ro \
-p 80:80 \
-d nginx