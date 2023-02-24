## 创建服务配置文件

```
cat <<'EOF'> /mnt/sdb/europa/europa-demo.ini
[local]
################################ europa(europa, cradle, jarvis, web-ssh-k8s, app-log-download)
## mysql
jdbc.url=jdbc:mysql://base-service-001.sc-host.lan:3306/europa?characterEncoding=UTF-8&rewriteBatchedStatements=true&useServerPrepStmts=false&autoReconnect=true&useSSL=false&user=root&password=%s
jdbc.url.password=admin11.1
## 启动环境
env=dev
## redis
redis.host=base-service-001.sc-host.lan
redis.port=6379
redis.timeout=3000

################################ k8s-api-server(web-ssh-k8s)

k8s.conf.obtain.url=http://base-service-001.sc-host.lan:9998/cradle/k8sCluster/all

################################ app-log-download(app-log-download)
## 单位MB
search.max.size=211
## 单位MB
monitor.log.size.threshold=10240
monitor.log.size.select=3
file.filter.day=150
app.prelog.son.path=bigdata
app.prelog.paths=/docker-logs/applogs

################################ fake prometheus
## 普罗米修斯
prometheus.query.url=http://prometheus.k8s.sc.lan
pro.config.url.list=[{\n	"name": "pro",\n	"active": true,\n	"url": "http://prometheus.k8s.sc.lan"\n}]

EOF
```

## 配置cradle服务

> 该服务用于调用Jenkins API进行服务构建

## 创建数据库

数据库脚本：[http://git.sc.lan/devops/europa/-/blob/master/dev/mysql.sql](http://git.sc.lan/devops/europa/-/blob/master/dev/mysql.sql)

创建数据库：

```bash
mysql -h <db_ip> -P <db_port> -u <username> -p <dbname> < mysql.sql
```

## 服务部署

**构建镜像：** [http://jenkins.sc.lan/jenkins/view/devops/job/cradle/](http://jenkins.sc.lan/jenkins/view/devops/job/cradle/)

```bash
cat <<'EOF'> /etc/systemd/system/cradle.service
[Unit]
Description=cradle docker wrapper
Wants=docker.socket
After=docker.service mysql.service redis.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
--name cradle-systemd \
--network host \
-v /mnt/sdb/europa/europa-demo.ini:/opt/application/conf/europa-demo.ini \
-v /mnt/sdb/europa/logs:/opt/application/logs \
docker.sc.lan/devops/cradle:master \
/bin/bash /opt/application/bin/detonator.sh start  -a '--server.port=9998'  -jo '-Xms256m -Xmx256m -Dini.path=/opt/application/conf/europa-demo.ini' -ssid

ExecStartPre=-/usr/bin/docker rm -f cradle-systemd
ExecStartPre=-/usr/bin/docker pull docker.sc.lan/devops/cradle:master
ExecStop=-/usr/bin/docker rm -f cradle-systemd

Restart=always
RestartSec=15s
TimeoutStartSec=50s

[Install]
WantedBy=multi-user.target

EOF

# 开机自启动
systemctl daemon-reload
systemctl enable cradle
systemctl start cradle

```

## 配置europa服务

> 该服务为DevOps平台主服务

**构建镜像：** [http://jenkins.sc.lan/jenkins/view/devops/job/europa/build?delay=0sec](http://jenkins.sc.lan/jenkins/view/devops/job/europa/build?delay=0sec)

```bash
cat <<'EOF'> /etc/systemd/system/europa.service
[Unit]
Description=europa docker wrapper
Wants=docker.socket
After=docker.service mysql.service redis.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
--name europa-systemd  \
--network host  \
-v /mnt/sdb/europa/europa-demo.ini:/opt/application/conf/europa-demo.ini \
-v /mnt/sdb/europa/logs:/opt/application/logs \
docker.sc.lan/devops/europa:master \
/bin/bash /opt/application/bin/detonator.sh start -a '--server.port=8943' -jo '-Xms256m -Xmx256m -Dini.path=/opt/application/conf/europa-demo.ini' -ssid

ExecStartPre=-/usr/bin/docker rm -f europa-systemd
ExecStartPre=-/usr/bin/docker pull docker.sc.lan/devops/europa:master
ExecStop=-/usr/bin/docker rm -f europa-systemd
Restart=always
RestartSec=15s
TimeoutStartSec=50s

[Install]
WantedBy=multi-user.target


EOF

# 开机自启动
systemctl daemon-reload
systemctl enable europa
systemctl start europa

```

## 配置europa-front

> 该服务为DevOps平台前端工程

**镜像构建：** [http://jenkins.sc.lan/jenkins/view/devops/job/europa-front/build?delay=0sec](http://jenkins.sc.lan/jenkins/view/devops/job/europa-front/build?delay=0sec)

```bash
cat <<'EOF'> /etc/systemd/system/europa-front.service
[Unit]
Description=europa-front docker wrapper
Wants=docker.socket
After=docker.service mysql.service redis.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
--name 'europa-front-systemd'  \
--network host    \
docker.sc.lan/devops/europa-front:master

ExecStartPre=-/usr/bin/docker rm -f europa-front-systemd
ExecStartPre=-/usr/bin/docker pull docker.sc.lan/devops/europa-front:master
ExecStop=-/usr/bin/docker rm -f europa-front-systemd
Restart=always
RestartSec=15s
TimeoutStartSec=50s

[Install]
WantedBy=multi-user.target

EOF

# 开机自启动
systemctl daemon-reload
systemctl enable europa-front
systemctl start europa-front

```

## 配置web-ssh-k8s

> 该服务为Kubernetes Web控制台

**镜像构建：** [http://jenkins.sc.lan/jenkins/view/devops/job/web-ssh-k8s/build?delay=0sec](http://jenkins.sc.lan/jenkins/view/devops/job/web-ssh-k8s/build?delay=0sec)

```bash
cat <<'EOF'> /etc/systemd/system/web-ssh-k8s.service
[Unit]
Description=web-ssh-k8s docker wrapper
Wants=docker.socket
After=docker.service mysql.service redis.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
--name 'web-ssh-k8s-systemd'  \
--network host     \
-v /mnt/sdb/europa/europa-demo.ini:/opt/application/conf/europa-demo.ini  \
-v /mnt/sdb/europa/logs:/opt/application/logs \
docker.sc.lan/devops/web-ssh-k8s:master \
/bin/bash /opt/application/bin/detonator.sh start -a '--server.port=8877' -jo '-Xms256m -Xmx256m -Dws.port=8866 -Dini.path=/opt/application/conf/europa-demo.ini' -ssid

ExecStartPre=-/usr/bin/docker rm -f web-ssh-k8s-systemd
ExecStartPre=-/usr/bin/docker pull docker.sc.lan/devops/web-ssh-k8s:master
ExecStop=-/usr/bin/docker rm -f web-ssh-k8s-systemd
Restart=always
RestartSec=15s
TimeoutStartSec=50s

[Install]
WantedBy=multi-user.target
EOF

# 开机自启动
systemctl daemon-reload
systemctl enable web-ssh-k8s
systemctl start web-ssh-k8s

```

## 配置Nginx反向代理

```bash
cat <<'EOF'> /etc/nginx/conf.d/europa.sc.lan.conf 
server {
    listen       80;
    server_name  europa.sc.lan;
    charset utf-8;
    add_header 'Access-Control-Allow-Origin' '*';
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Methods ' 'GET, POST, PUT, DELETE, OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'Accept,Authorization,Cache-Control,Content-Type,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Requested-With,authToken';
    proxy_http_version 1.1;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_max_temp_file_size 10240m;
    
    
    location = /index {
                return 301 " /";
    }
    location = /index.html {
       proxy_pass   http://127.0.0.1:8007;
    }
    location = / {
      proxy_set_header "Host" "europa.sc.lan";
      proxy_pass   http://127.0.0.1:8007;
    }
    location ~* \.(css|scss|html|js|xml|htm|jpg|gif|jpeg|png|ico|json|ttf|woff|svg)$ {
            access_log off;
            charset utf-8;
	    proxy_pass   http://127.0.0.1:8007;
    }

    location ^~ /check/authentication {
      proxy_set_header "Host" "europa.sc.lan";
      proxy_pass   http://127.0.0.1:8943;
    }
    location ^~ /oauth {
      proxy_set_header "Host" "europa.sc.lan";
      proxy_pass   http://127.0.0.1:8943;
          
    }

    location ^~ /logout {
        proxy_set_header "Host" "europa.sc.lan";
        proxy_pass   http://127.0.0.1:8943;
    }

    location ^~ /europa {

        proxy_set_header "Host" "europa.sc.lan";
        proxy_pass   http://127.0.0.1:8943;

    }
    
    location ^~ /cradle {
        proxy_set_header "Host" "europa.sc.lan";
        proxy_pass   http://127.0.0.1:9998;
      
    }
    
    location ^~ /web-ssh-k8s-websocket {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header "Host" "europa.sc.lan";
        proxy_pass   http://127.0.0.1:8866;
    }


    location ^~ /app-log-download {
        proxy_set_header "Host" "europa.sc.lan";
        proxy_pass   http://172.26.228.18:8587;
    }

    location / {
        try_files $uri $uri/ /index.html;

     }

}

```

## 检验

[http://europa.sc.lan/](http://europa.sc.lan/)

## 其它

因为app-log-download必须以daemonset方式部署, 所以依赖于k8s, 而不是docker , 这里贴出docker启动方式, 方便自测启动相关问题

```bash
docker run -d  --name 'app-log-download' --network host    -v /mnt/sdb/europa/europa-demo.ini:/opt/europa/europa-demo.ini -v /mnt/sdb/europa/logs:/opt/app-log-download/logs upload.docker.sc.lan/devops/app-log-download:demo-weiqi  /bin/bash /opt/app-log-download/bin/app-log-download start   -sn 'app-log-download'  -a '--server.port=8587'  -jo '-Xms256m -Xmx256m -Dini.path=/opt/europa/europa-demo.ini' -ssid -ao false
```