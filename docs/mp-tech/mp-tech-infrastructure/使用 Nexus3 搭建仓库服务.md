# 配置Systemd
```bash
cat <<EOF>  /etc/systemd/system/nexus3.service
[Unit]
Description=nexus3 docker wrapper
Wants=docker.socket
After=docker.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
                          -v nexus3-data:/nexus-data \
                          --name nexus3-systemd \
                          --net=host \
                          --restart=on-failure:5 \
                          sonatype/nexus3:3.25.0
ExecStartPre=-/usr/bin/docker volume create --name nexus3-data
ExecStartPre=-/usr/bin/docker rm -f nexus3-systemd
ExecStop=/usr/bin/docker rm -rf nexus3-systemd
Restart=always
RestartSec=15s
TimeoutStartSec=30s

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nexus3
systemctl start nexus3
```
# 配置HTTP代理
注意：准备好HTTP代理（shadowsocks + privoxy）

`http://ip:8081 > System > HTTP`

```yaml
HTTP Proxy:
    HTTP proxy host: <your HTTP proxy IP>
    HTTP proxy port: <your HTTP proxy port>
HTTPS Proxy:
    HTTP proxy host: <your HTTP proxy IP>
    HTTP proxy port: <your HTTP proxy port>
Hosts to exclude from HTTP/HTTPS proxy:
    - *.lan
```
# Docker Repos
## 代理仓库设置
用途：加速外网镜像下载
### 代理官方镜像仓库
`http://ip:8081 > Repository > Repositories > Create Repository > docker (proxy)`
```yaml
"Name": docker-offical
"Proxy":
    "Remote storage": https://registry-1.docker.io
    "Docker Index": "Use Docker Hub"
```
### 代理第三方镜像仓库
`http://ip:8081 > Repository > Repositories > Create Repository > docker (proxy)`
#### k8s.gcr.io
```yaml
"Name": docker-gcr.io
"Proxy":
    "Remote storage": https://k8s.gcr.io
    "Docker Index": "Use proxy registry"
```
#### quay.io
```yaml
"Name": docker-quay.io
"Proxy":
    "Remote storage": https://quay.io
    "Docker Index": "Use proxy registry"
```
## 创建Hosted仓库
用途：存放自己上传的镜像

`http://ip:8081 > Repository > Repositories > Create Repository > docker (hosted)`

```yaml
"Name": docker-hosted
"Repository Connectors":
    "HTTP": 18887 # 打勾
    "Allow anonymous docker pull": 打勾
```
## 创建组仓库（public）
`http://ip:8081 > Repository > Repositories > Create Repository > docker (group)`
```yaml
"Name": docker-all
"Repository Connectors":
    "HTTP": 18888 # 打勾
    "Allow anonymous docker pull": 打勾
"Group":
    "Member repositories:"
        "Members:"
            - docker-hosted
            - docker-offical
            - docker-gcr.io
```
## 修改权限
`http://ip:8081 > Security > Realms`
```yaml
Active realms:
    Active:
        - Docker Bearer Token Realm # 添加
```
## 配置Nginx反向代理（可选）
```bash
# Nexus Web
cat <<EOF> nexus3.sc.lan.conf 
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

# Docker public repo
cat <<EOF> /etc/nginx/conf.d/docker.sc.lan.conf 
server {
    listen 80;
    server_name docker.sc.lan;
    location / {
        proxy_pass http://127.0.0.1:18888;
    }
}
EOF

# Docker upload repo
cat <<EOF> /etc/nginx/conf.d/upload.docker.sc.lan.conf 
server {
    listen 80;
    server_name upload.docker.sc.lan;
    client_max_body_size 4096m;
    location / {
        proxy_pass http://127.0.0.1:18887;
    }
}
EOF

systemctl reload nginx
```
**注意：** 需要将域名加入到DNS或HOSTS中，指向本机
## 配置Docker
```bash
vim /etc/docker/daemon.json
---------------------------
{
  "registry-mirrors": ["http://docker.sc.lan"],
  "insecure-registries" : ["docker.sc.lan","upload.docker.sc.lan"]
}

systemctl reload docker
```
## 测试
```bash
# 测试官方代理仓库是否正常
docker pull alpine

# 测试第三方代理仓库(k8s.gcr.io)是否正常
docker pull docker.softcenter.lan/kube-proxy:v1.18.6

# 登录 输入nexus3的帐号密码
docker login upload.docker.softcenter.lan

# 测试私有仓库上传功能
docker tag alpine:latest upload.docker.softcenter.lan/alpine:test
docker push upload.docker.softcenter.lan/alpine:test

# 测试私有仓库下载
docker pull docker.softcenter.lan/alpine:test
```
# 参考
[Using Nexus OSS as a proxy/cache for Docker images](https://mtijhof.wordpress.com/2018/07/23/using-nexus-oss-as-a-proxy-cache-for-docker-images/)

[How to add k8s.gcr.io as docker proxy](https://community.sonatype.com/t/how-to-add-k8s-gcr-io-as-docker-proxy/1614)

[Run Behind a Reverse Proxy](https://help.sonatype.com/repomanager3/installation/run-behind-a-reverse-proxy)