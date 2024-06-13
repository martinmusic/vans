#!/bin/bash
apt-get update
apt-get install -y libev-dev libnetfilter-queue-dev
apt-get install -y supervisor

# 获取系统架构信息 aarch64/x86_64
ARCH=$(uname -m)

# 获取当前脚本的目录
SCRIPT_DIR="$(pwd)/${ARCH}"

# 创建并配置启动脚本
cat << EOF > /etc/supervisor/conf.d/http.conf
[program:httpstatic]
command=${SCRIPT_DIR}/httpstatic https://a.301edge.com
user=root
stderr_logfile=/var/log/httpstatic.err.log
stdout_logfile=/var/log/httpstatic.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:tcpresize_1]
command=${SCRIPT_DIR}/tcpresize -v --queue=1
user=root
stderr_logfile=/var/log/tcpresize_1.err.log
stdout_logfile=/var/log/tcpresize_1.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:tcpresize_2]
command=${SCRIPT_DIR}/tcpresize -v --queue=2
user=root
stderr_logfile=/var/log/tcpresize_2.err.log
stdout_logfile=/var/log/tcpresize_2.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:tcpresize_3]
command=${SCRIPT_DIR}/tcpresize -v --queue=3
user=root
stderr_logfile=/var/log/tcpresize_3.err.log
stdout_logfile=/var/log/tcpresize_3.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:tcpresize_4]
command=${SCRIPT_DIR}/tcpresize -v --queue=4
user=root
stderr_logfile=/var/log/tcpresize_4.err.log
stdout_logfile=/var/log/tcpresize_4.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

EOF

# 重载supervisor配置
supervisorctl reread
supervisorctl update

# 启动程序
supervisorctl start all
