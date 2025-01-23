#!/bin/bash

# Check if libev-dev is installed
dpkg -s libev-dev &> /dev/null
if [ $? -ne 0 ]; then
    apt-get update
    apt-get install -y libev-dev
fi

# Check if libnetfilter-queue-dev is installed
dpkg -s libnetfilter-queue-dev &> /dev/null
if [ $? -ne 0 ]; then
    apt-get install -y libnetfilter-queue-dev
fi

# Check if supervisor is installed
dpkg -s supervisor &> /dev/null
if [ $? -ne 0 ]; then
    apt-get install -y supervisor
fi

# 获取系统架构信息 aarch64/x86_64
ARCH=$(uname -m)

# 获取当前脚本的目录
SCRIPT_DIR="$(pwd)/${ARCH}"
URL=${1:-https://a.301edge.com}

# 创建并配置启动脚本
cat << EOF > /etc/supervisor/conf.d/http.conf
[program:tcpresize_4]
command=${SCRIPT_DIR}/tcpresize -v --queue=4
user=root
stderr_logfile=/var/log/tcpresize_4.err.log
stdout_logfile=/var/log/tcpresize_4.out.log
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
