#!/bin/bash
REMOTE_USER="ts"
REMOTE_IP="4.tangsu.icu"
SYNC_DIR="$HOME/vscode/"
LOG_FILE="$HOME/sync.log"
touch $LOG_FILE
# 双向同步（可选单向）
rsync -avz  -e "ssh -i $HOME/.ssh/id_rsa" $REMOTE_USER@$REMOTE_IP:$SYNC_DIR $SYNC_DIR >> $LOG_FILE 2>&1
# 远程覆盖本地
# rsync -avz --delete -e "ssh -i $HOME/.ssh/id_rsa" $REMOTE_USER@$REMOTE_IP:$SYNC_DIR/ $SYNC_DIR >> $LOG_FILE 2>&1

# 本地上传远程
# rsync -avz  -e "ssh -i $HOME/.ssh/id_rsa" $SYNC_DIR $REMOTE_USER@$REMOTE_IP:$SYNC_DIR >> $LOG_FILE 2>&1

date >> $LOG_FILE
