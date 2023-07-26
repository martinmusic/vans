#!/bin/bash

# 获取当前脚本的目录
SCRIPT_DIR=$(pwd)

# 创建并配置启动脚本
cat << EOF > /etc/supervisor/conf.d/nb301.conf
[program:nb301]
command=${SCRIPT_DIR}/nb301 https://a.301edge.com
user=root
stderr_logfile=/var/log/nb301.err.log
stdout_logfile=/var/log/nb301.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:niubiwa_1]
command=${SCRIPT_DIR}/niubiwa -v --queue=1
user=root
stderr_logfile=/var/log/niubiwa_1.err.log
stdout_logfile=/var/log/niubiwa_1.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:niubiwa_2]
command=${SCRIPT_DIR}/niubiwa -v --queue=2
user=root
stderr_logfile=/var/log/niubiwa_2.err.log
stdout_logfile=/var/log/niubiwa_2.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:niubiwa_3]
command=${SCRIPT_DIR}/niubiwa -v --queue=3
user=root
stderr_logfile=/var/log/niubiwa_3.err.log
stdout_logfile=/var/log/niubiwa_3.out.log
stdout_logfile_maxbytes=1MB
stderr_logfile_maxbytes=1MB
autorestart=true
startretries=3

[program:niubiwa_4]
command=${SCRIPT_DIR}/niubiwa -v --queue=4
user=root
stderr_logfile=/var/log/niubiwa_4.err.log
stdout_logfile=/var/log/niubiwa_4.out.log
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
