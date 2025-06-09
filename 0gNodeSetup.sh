#!/bin/bash

# Add 0G-Galileo-Testnet chain from here: https://docs.0g.ai/run-a-node/testnet-information
# Faucet: https://faucet.0g.ai/

set -euo pipefail

# Update & install dependencies
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install curl iptables build-essential git wget lz4 jq make cmake gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev screen ufw -y

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"
rustc --version || echo "Rust installation failed"

# Install Go (v1.24.3)
GO_VERSION=1.24.3
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

# Add Go to PATH for current script
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

go version || echo "⚠️ Go installation failed or path not set"

# Install 0G Storage Node
git clone https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git checkout v1.0.0
git submodule update --init
cargo build --release

# Download fresh config
CONFIG_PATH="$HOME/0g-storage-node/run/config.toml"
rm -rf "$CONFIG_PATH"
mkdir -p "$(dirname "$CONFIG_PATH")"
curl -o "$CONFIG_PATH" https://raw.githubusercontent.com/mohsinsmsn/0gnode/refs/heads/main/config.toml

# Prompt user for private key
exec < /dev/tty
echo ""
echo "👉 Enter your private key (must start with 0x and be 66 characters long):"
read -e -p "Private Key: " PRIVATE_KEY

# Keep asking until valid input is received
while [[ ! "$PRIVATE_KEY" =~ ^0x[a-fA-F0-9]{64}$ ]]; do
  echo "❌ Invalid private key format. Do not Add 0x In Your Private Key."
  read -e -p "Please re-enter your private key: " PRIVATE_KEY
done

# Update the miner_key in config.toml
if grep -q "^miner_key" "$CONFIG_PATH"; then
  sed -i "s/^miner_key.*/miner_key = \"$PRIVATE_KEY\"/" "$CONFIG_PATH"
else
  echo "miner_key = \"$PRIVATE_KEY\"" >> "$CONFIG_PATH"
fi

echo "✅ Private key successfully updated in config.toml"

# Create systemd service
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable zgs
sudo systemctl start zgs
