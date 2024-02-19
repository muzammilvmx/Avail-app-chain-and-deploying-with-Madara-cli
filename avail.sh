#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install git and curl
sudo apt-get install git-all curl -y

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Install Necessary Dependencies
sudo apt install build-essential pkg-config libssl-dev clang protobuf-compiler -y

# Install Docker
# Set up Docker apt repository
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Test Docker
sudo docker run hello-world

# Clone Madara CLI Git Repo
git clone https://github.com/karnotxyz/madara-cli
cd madara-cli

# Build Madara CLI
cargo build --release

# Install screen
sudo apt install screen -y

# Initialize App-chain and get Avail-address
avail_address=$(./target/release/madara init)

# Provide user instructions to deposit or load faucet and continue
echo "Your Avail address is: $avail_address"
echo "Deposit or load the faucet to this address."
read -p "When ready, press Enter to continue..."

# Run app-chain in a screen session
screen -dmS madara ./target/release/madara run

# Allow necessary ports
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 9944
sudo ufw allow 4000
sudo ufw allow 9615
sudo ufw allow 30333

# Start the Explorer
./target/release/madara explorer
