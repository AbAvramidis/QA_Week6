#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo groupadd docker
sudo usermod -aG docker vagrant 
sudo systemctl restart docker
sudo systemctl enable docker