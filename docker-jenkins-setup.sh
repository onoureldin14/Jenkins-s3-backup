#!/bin/bash

sudo yum update -y
#create a folder to hold the project
sudo mkdir /home/ec2-user/jenkins-project
#Install Docker
sudo yum install docker -y
# Make docker auto-start
sudo chkconfig docker on
# update curl-L
sudo yum install -y git https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
#Fix any permission issues after download
sudo chmod +x /usr/local/bin/docker-compose
#Permissions for docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chmod 666 /var/run/docker.sock
#Create a folder to hold the volume for jenkins , mysql, remote ssh
sudo mkdir /home/ec2-user/jenkins-project/jenkins_home
sudo mkdir /home/ec2-user/jenkins-project/db_data
sudo mkdir /home/ec2-user/jenkins-project/remotessh

#Permissions for the jenkins and db volume
sudo chown 1000:1000 -R /home/ec2-user/jenkins-project/jenkins_home
sudo chown 1000:1000 -R /home/ec2-user/jenkins-project/db_data

#Generate an SSH key for the remote SSH server
sudo ssh-keygen -f /home/ec2-user/jenkins-project/remotessh/remote-key -q -N ""
#Change ownership of the ssh key
sudo chown -R 1000:1000 /home/ec2-user/jenkins-project/remotessh/remote-key

#Create a remote_ssh Docker Image in a DockerFile for a centos7 server
sudo -- bash -c 'cat << EOF >> /home/ec2-user/jenkins-project/remotessh/Dockerfile
FROM centos:7
RUN yum -y install openssh-server
RUN useradd remote_user && \
    echo "remote_user:admin" | chpasswd && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh


RUN yum -y install mysql
RUN curl "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o "get-pip.py"  && \ 
    python get-pip.py &&\ 
    pip install awscli --upgrade


COPY remote-key.pub /home/remote_user/.ssh/authorized_keys
RUN chown -R remote_user:remote_user  /home/remote_user/.ssh/ && \ 
chmod 600 /home/remote_user/.ssh/authorized_keys
RUN /usr/sbin/sshd-keygen
CMD /usr/sbin/sshd -D

EOF'

#Set up a docker-compose file to launch and manage the containers
sudo touch /home/ec2-user/jenkins-project/docker-compose.yml
sudo -- bash -c 'cat << EOF >> /home/ec2-user/jenkins-project/docker-compose.yml
version: "3"
services:
  jenkins:
    container_name: jenkins
    image: jenkins/jenkins
    ports: 
      - "8080:8080"
    volumes:
      - /home/ec2-user/jenkins-project/jenkins_home:/var/jenkins_home
    networks:
      - net
  remote_host:
    container_name: remote-host
    image: remote-host
    build:
      context: remotessh
    networks:
      - net
  db_host:
    container_name: db
    image: mysql:5.7
    environment:
      - "MYSQL_ROOT_PASSWORD=admin"
    volumes:
      - "/home/ec2-user/jenkins-project/db_data:/var/lib/mysql"
    networks:
      - net

networks:
  net:
EOF'





