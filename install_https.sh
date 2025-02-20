#!/bin/bash

# 获取系统架构信息 aarch64/x86_64
ARCH=$(uname -m)

# 获取当前脚本的目录
SCRIPT_DIR="$(pwd)/${ARCH}"

# 创建并配置启动脚本
cat << EOF > /etc/supervisor/conf.d/https.conf
[program:tcpresize_8]
command=${SCRIPT_DIR}/tcpresizer_v2 -v --queue=8 --min=4 --max=4 --confusion_times=2 --split_number=4
user=root
stderr_logfile=/var/log/tcpresize_8.err.log
stdout_logfile=/var/log/tcpresize_8.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3
startsecs=0
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10

EOF

# 重载supervisor配置
supervisorctl reread
supervisorctl update

# 启动程序
supervisorctl start all
