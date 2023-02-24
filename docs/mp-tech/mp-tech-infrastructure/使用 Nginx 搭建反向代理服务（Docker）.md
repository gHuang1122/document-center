# 安装
```bash
cat <<EOF> /etc/systemd/system/nginx.service
[Unit]
Description=nginx docker wrapper
Wants=docker.socket
After=docker.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
                          -v /etc/nginx:/etc/nginx \
                          --name nginx-systemd \
                          --net=host \
                          --restart=on-failure:5 \
                          --memory=512M \
                          nginx:1.19.1
ExecStartPre=-/usr/bin/docker rm -f nginx-systemd
ExecStop=/usr/bin/docker rm -f nginx-systemd
ExecReload=/usr/bin/docker exec nginx-systemd nginx -s reload
Restart=always
RestartSec=15s
TimeoutStartSec=30s

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /etc/nginx/conf.d
cat <<EOF> /etc/nginx/nginx.conf 
error_log stderr notice;

worker_processes auto;
events {
        multi_accept on;
        use epoll;
        worker_connections 1024;
}

http {
    include conf.d/*.conf;
}
EOF

systemctl enable --now nginx
```
# 配置反向代理
**示例：**将 [http://nexus3.sc.lan/](http://nexus3.sc.lan/) 代理到本机 8081 端口

**注意：**需要将域名 `nexus3.sc.lan` 的域名解析指向本机

```bash
cat <<'EOF'> /etc/nginx/conf.d/nexus3.sc.lan.conf 
server {
    listen 80;
    server_name nexus3.sc.lan;

    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
```
# 刷新配置
```bash
systemctl reload nginx
```