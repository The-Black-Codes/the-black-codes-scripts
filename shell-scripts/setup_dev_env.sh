#!/bin/bash

# Function to check if a command exists
function check_installation() {
    if ! [ -x "$(command -v $1)" ]; then
        echo "$1 is not installed. Installing $1..."
        return 1
    else
        echo "$1 is already installed."
        return 0
    fi
}

# Update system packages
echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Install Git
check_installation git
if [ $? -ne 0 ]; then
    sudo apt install git -y
fi

# Install Python
check_installation python3
if [ $? -ne 0 ]; then
    sudo apt install python3 python3-pip -y
fi

# Install Node.js (via NodeSource)
check_installation node
if [ $? -ne 0 ]; then
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Install Docker
check_installation docker
if [ $? -ne 0 ]; then
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install docker-ce -y
    sudo usermod -aG docker $USER  # Allow user to run docker commands without sudo
fi

# Install Docker Compose
check_installation docker-compose
if [ $? -ne 0 ]; then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Clean up and finish
echo "Cleaning up..."
sudo apt autoremove -y
echo "Development environment setup complete!"

