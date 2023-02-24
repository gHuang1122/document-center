## 创建Mysql配置文件

```bash
mkdir /mnt/sdb/mysql/data -p
cat <<'EOF'> /mnt/sdb/mysql/my.cnf
[client]
default-character-set=utf8mb4

[mysqld]
character-set-client-handshake = FALSE

character-set-server = utf8mb4

collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set=utf8mb4

EOF
```

## 配置Systemd(Mysql)

```bash
cat <<'EOF'> /etc/systemd/system/gitlab.service
[Unit]
Description=mysql docker wrapper
Wants=docker.socket
After=docker.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
--restart always -p 3306:3306 -v /mnt/sdb/mysql/my.cnf:/etc/mysql/mysql.conf.d/my.cnf -v /mnt/sdb/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=admin11.1 --name mysql mysql:5.7.18
ExecStartPre=-/usr/bin/docker rm -f mysql
ExecStop=-/usr/bin/docker rm -f mysql
Restart=always
RestartSec=15s
TimeoutStartSec=50s

[Install]
WantedBy=multi-user.target


EOF

# 开机自启动
systemctl daemon-reload
systemctl enable mysql
systemctl start mysql

```

## 配置Systemd(Redis)

```bash
cat <<'EOF'> /etc/systemd/system/redis.service
[Unit]
Description=redis docker wrapper
Wants=docker.socket
After=docker.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
--restart always --name redis -p 6379:6379 redis:4.0.11
ExecStartPre=-/usr/bin/docker rm -f redis
ExecStop=-/usr/bin/docker rm -f redis
Restart=always
RestartSec=15s
TimeoutStartSec=50s

[Install]
WantedBy=multi-user.target

EOF

# 开机自启动
systemctl daemon-reload
systemctl enable redis
systemctl start redis

```


## 测试

telnet 127.0.0.1 3306

telnet 127.0.0.1 6379