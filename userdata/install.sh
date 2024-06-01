#!/bin/bash -i

# This script updates system packages, installs Docker, Nginx, Node.js, and starts their services.

# Update system packages
sudo apt update -y

# Install Docker and Nginx
sudo apt install -y docker.io nginx

# Start and enable Docker and Nginx services
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Node.js using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs