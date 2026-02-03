#!/bin/bash

set -e   # Stop script if any command fails

echo "Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing required packages..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "Installing Docker..."
curl -fsSL https://get.docker.com | sudo bash

echo "Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding vagrant user to docker group..."
sudo usermod -aG docker vagrant

echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo "Docker installation completed!"

echo "Waiting for Docker to become ready..."
sleep 5

echo "Copying Dockerfile into /home/vagrant (if present)..."
if [ -f /vagrant/Dockerfile ]; then
    sudo cp /vagrant/Dockerfile /home/vagrant/Dockerfile
    sudo chown vagrant:vagrant /home/vagrant/Dockerfile
    echo "Dockerfile copied to /home/vagrant/Dockerfile"
else
    echo "Warning: /vagrant/Dockerfile not found. Will attempt to build from /vagrant if possible."
fi

IMAGE_NAME="tween-marketing"
CONTAINER_NAME="tween"

echo "Building Docker image '$IMAGE_NAME' from /vagrant..."
sudo docker build -t "$IMAGE_NAME" /vagrant

echo "Stopping and removing any existing container named '$CONTAINER_NAME'..."
sudo docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "Running container '$CONTAINER_NAME' (host port 8080 -> container port 80)..."
sudo docker run -d --name "$CONTAINER_NAME" -p 8080:80 --restart unless-stopped "$IMAGE_NAME"

echo "Docker container started. Access the site on the host at http://localhost:8080 (or VM IP)."


echo "Setup complete."