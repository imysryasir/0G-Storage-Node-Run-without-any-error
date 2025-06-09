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

# Important Commands
## Check Node Status
```
sudo systemctl status zgs
```
## Logs
```
tail -f ~/0g-storage-node/run/log/zgs.log.$(TZ=UTC date +%Y-%m-%d)
```
## Sync Check For Blocks
 ```
while true; do     response=$(curl -s -X POST http://localhost:5678 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}');     logSyncHeight=$(echo $response | jq '.result.logSyncHeight');     connectedPeers=$(echo $response | jq '.result.connectedPeers');     echo -e "logSyncHeight: \033[32m$logSyncHeight\033[0m, connectedPeers: \033[34m$connectedPeers\033[0m";     sleep 5; done
```
### To Edit Your File > Change your RPC / Key
```
nano $HOME/0g-storage-node/run/config.toml
```
### Get New RPC from here : https://www.astrostake.xyz/0g-status


## Restarting node Next day

### Reload
```
sudo systemctl daemon-reload
```
### Enable
```
sudo systemctl enable zgs
```
### Start service
```
sudo systemctl start zgs
```

# To Stop & Delete your Node 

## Stop
```
sudo systemctl stop zgs
```
## Delete
```
sudo systemctl disable zgs
sudo rm /etc/systemd/system/zgs.service
rm -rf $HOME/0g-storage-node
```

