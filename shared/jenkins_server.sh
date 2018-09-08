#!/bin/bash
sudo yum install -y git
sudo yum install -y wget nano 
sudo yum install -y epel-release
sudo yum update -y
sudo useradd jenkins
sudo yum install -y java-1.8.0-openjdk.x86_64
cd ~ && sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service