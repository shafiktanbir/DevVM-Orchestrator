#!/bin/bash

# Update packages
sudo apt update -y

# Install Java (required for Jenkins)
sudo apt install -y fontconfig openjdk-21-jre

# Verify Java installation
java -version

# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Add Jenkins repository key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# Update repositories again
sudo apt update -y

# Install Jenkins
sudo apt install -y jenkins

# Enable Jenkins service at boot
sudo systemctl enable jenkins

# Start Jenkins
sudo systemctl start jenkins

# Show status
sudo systemctl status jenkins