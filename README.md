# 0G Storage Node 1 Click-Setup ✅

---
## Minimum System Requirements | 32gb Ram | 6 Core CPU | 1tb SSD |

--- 

# Full Video Guide : https://t.me/kind_cr

## First Thing to do is create a new Burner wallet and take faucets
### Faucet Link : https://faucet.0g.ai/
## Deploy
```
curl -o 0GNodeSetup.sh https://raw.githubusercontent.com/imysryasir/0G-Storage-Node-Run-without-any-error/refs/heads/main/0gNodeSetup.sh &&
chmod +x 0GNodeSetup.sh &&
./0GNodeSetup.sh
```

### To Edit Your File > Change your RPC / Key
```
nano $HOME/0g-storage-node/run/config.toml
```
### Get New RPC from here : https://www.astrostake.xyz/0g-status


## Restarting node Next day

### Reload
sudo systemctl daemon-reload

### Enable
sudo systemctl enable zgs

### Start service
sudo systemctl start zgs


# To Stop & Delete your Node 

## Stop
sudo systemctl stop zgs

## Delete
sudo systemctl disable zgs
sudo rm /etc/systemd/system/zgs.service
rm -rf $HOME/0g-storage-node


