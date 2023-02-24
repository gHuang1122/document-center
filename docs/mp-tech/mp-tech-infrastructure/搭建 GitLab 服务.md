# 配置Systemd


```bash
cat <<'EOF'> /etc/systemd/system/gitlab.service
[Unit]
Description=gitlab docker wrapper
Wants=docker.socket
After=docker.service

[Service]
User=root
PermissionsStartOnly=true
# 先手动执行如下语句
# docker run -d --name gitlab-systemd \
#           -e GITLAB_OMNIBUS_CONFIG="external_url 'http://git.sc.lan/'; nginx['listen_port']=8181" \
#           -p 8181:8181 \
#           -v /etc/gitlab:/etc/gitlab \
#           -v /var/log/gitlab:/var/log/gitlab \
#           -v /var/opt/gitlab:/var/opt/gitlab \
#           --restart=on-failure:5 \
#           gitlab/gitlab-ce:13.2.1-ce.0
ExecStart=/usr/bin/docker start -a gitlab-systemd
ExecStop=/usr/bin/docker stop -t 60 gitlab-systemd
ExecReload=/usr/bin/docker exec gitlab-systemd gitlab-ctl reconfigure
Restart=always
RestartSec=15s
TimeoutStartSec=30s

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now  gitlab
```


# 添加反向代理配置
```bash
cat <<EOF> git.sc.lan.conf 
server {
    listen 80;
    server_name git.sc.lan;
    location / {
        proxy_pass http://127.0.0.1:8181;
    }
}
EOF
```
# 校验
使用浏览器访问 [http://git.sc.lan/](http://git.sc.lan/)
# 参考


[GitLab Docker images](https://docs.gitlab.com/omnibus/docker/)
