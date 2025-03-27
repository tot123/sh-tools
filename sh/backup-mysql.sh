作者：苏琢玉
链接：https://zhuanlan.zhihu.com/p/29366979998
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

#!/bin/bash

# MySQL连接参数（可以使用 ~/.my.cnf 文件代替）
DB_USER="数据库账号"
DB_PASS="数据库密码"

# 备份目录
BACKUP_DIR="/数据库备份目录"

# 日志文件路径
CURRENT_DATE=$(date +'%Y%m%d%H%M%S')
LOG_FILE="/数据库备份日志目录/$CURRENT_DATE.log"

# 目标服务器的 SSH 用户名和 IP 地址，如果不需要同步到其他服务器则不需要填写
# -----------------------------
REMOTE_USER="" # 目标服务器账号
REMOTE_HOST="" #目标服务器IP
REMOTE_DIR="" # 目标服务器存储路径
# -----------------------------

# SSH 连接超时时间（单位：秒）
SSH_CONNECT_TIMEOUT=10

# 创建备份和日志目录（如果不存在）
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# 获取所有数据库列表
DATABASES=$(mysql -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

# 循环备份每个数据库
BACKUP_FILES=()
for DB in $DATABASES; do
    BACKUP_FILE="$BACKUP_DIR/$DB-$CURRENT_DATE.sql.gz"
    echo "$(date +%Y%m%d%H%M%S) 备份数据库 $DB 到文件 $BACKUP_FILE" >> $LOG_FILE
    if ! mysqldump -u $DB_USER -p$DB_PASS --single-transaction --databases $DB | gzip > $BACKUP_FILE; then
        echo "$(date +%Y%m%d%H%M%S) 备份数据库 $DB 失败" >> $LOG_FILE
        continue  # 跳过当前数据库，继续备份其他数据库
    fi
    echo "$(date +%Y%m%d%H%M%S) 备份完成" >> $LOG_FILE
    BACKUP_FILES+=($BACKUP_FILE)
done

# 创建远程备份目录
if [ -n "$REMOTE_USER" ] && [ -n "$REMOTE_HOST" ] && [ -n "$REMOTE_DIR" ]; then
    ssh -o ConnectTimeout=$SSH_CONNECT_TIMEOUT $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_DIR"

    # 批量传输备份文件
    if [ ${#BACKUP_FILES[@]} -gt 0 ]; then
        echo "$(date +%Y%m%d%H%M%S) 将备份文件发送到远程服务器..." >> $LOG_FILE
        scp -o ConnectTimeout=$SSH_CONNECT_TIMEOUT ${BACKUP_FILES[@]} $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
        echo "$(date +%Y%m%d%H%M%S) 备份文件发送完成" >> $LOG_FILE
    fi

    # 删除本地备份文件
    echo "删除本地备份文件..." >> $LOG_FILE
    for BACKUP_FILE in "${BACKUP_FILES[@]}"; do
        rm -f $BACKUP_FILE
    done
    echo "本地备份文件删除完成" >> $LOG_FILE
fi

# 完成
echo "------------------------------" >> $LOG_FILE