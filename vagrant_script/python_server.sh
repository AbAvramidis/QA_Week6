#!/bin/bash
sudo yum install -y git
sudo yum update
sudo useradd jenkins
sudo git clone https://github.com/bob-crutchley/python-systemd-http-server.git && cd python-systemd-http-server
sudo make install
sudo systemctl daemon-reload
sudo systemctl start python-systemd-http-server.service
sudo systemctl status python-systemd-http-server.service
	