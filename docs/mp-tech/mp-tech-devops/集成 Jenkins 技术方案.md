# 一、简介
DevOps 平台使用开源系统 Jenkins 作为代码构建工具进行工程构建。Jenkins 拥有极佳的扩展性属于目前开源产品中最好用的构建工具之一。

DevOps 平台与 Jenkins 之间通过 Jenkins API 进行交互，Jenkins API 拥有完整的鉴权功能，无需担心 API 暴露等相关安全性问题。

# 二、Jenkins 搭建流程
## 配置 Java 环境
```bash
mkdir -p /usr/java && cd /usr/java
wget "https://mirrors.huaweicloud.com/java/jdk/8u201-b09/jdk-8u201-linux-x64.tar.gz"
tar -zxvf jdk-8u201-linux-x64.tar.gz 
ln  /usr/java/jdk1.8.0_201/  default
cat <<'EOF'> /etc/profile.d/java.sh
JAVA_HOME=/usr/java/default
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
PATH=$JAVA_HOME/bin:$PATH
EOF
source /etc/profile
java -version
```
## 配置 Maven 环境
使用软连接, 让Jenkins容器内部的maven和宿主机的maven缓存的jar包存储到相同的地方
```bash
# 创建容器内外的软连接
mkdir /mnt/sdb/jenkins_home/maven/apache-maven-lib/repository -p
mkdir /var/jenkins_home/maven/apache-maven-lib -p
ln -s /mnt/sdb/jenkins_home/maven/apache-maven-lib/repository  /var/jenkins_home/maven/apache-maven-lib/repository

# 解压maven并配置环境变量
cd /var/jenkins_home/maven
tar -zxvf apache-maven-3.6.0.tar.gz
cat <<'EOF'>/etc/profile.d/maven.sh
MAVEN_HOME=/mnt/sdb/jenkins_home/maven/apache-maven-3.6.0
export MAVEN_HOME
export PATH=${PATH}:${MAVEN_HOME}/bin
EOF
source /etc/profile
mvn -v

# 配置maven的config.xml, 修改相关标签
@@@
 <localRepository>/var/jenkins_home/maven/apache-maven-lib/repository</localRepository>
@@@
 <server>
   <id>releases</id>
   <username>admin</username>
   <password>admin11.1</password>
 </server>
 <server>
   <id>snapshots</id>
   <username>admin</username>
   <password>admin11.1</password>
 </server> 
@@@
<mirror>
  <id>neuxs-sc</id>
  <mirrorOf>*</mirrorOf>
  <name>the maven repository</name>
  <url>http://nexus3.sc.lan/repository/maven-public/</url>
</mirror>
@@@

# 个别jar包下载不了, 手动install
mvn install:install-file -DgroupId=com.alibaba -DartifactId=dubbo -Dversion=2.8.4 -Dpackaging=jar -Dfile=/mnt/sdb/jenkins_home/maven/dubbo-2.8.4.jar
mvn install:install-file -DgroupId=javax.jms -DartifactId=jms -Dversion=1.1 -Dpackaging=jar -Dfile=/mnt/sdb/jenkins_home/maven/jms-1.1.jar
mvn install:install-file -DgroupId=com.sun.jdmk -DartifactId=jmxtools -Dversion=1.2.1 -Dpackaging=jar -Dfile=/mnt/sdb/jenkins_home/maven/jmxtools-1.2.1.jar
mvn install:install-file -DgroupId=com.sun.jmx -DartifactId=jmxri -Dversion=1.2.1 -Dpackaging=jar -Dfile=/mnt/sdb/jenkins_home/maven/jmxri-1.2.1.jar

```
## 自定义Jenkins镜像
```dockerfile
cat <<'EOF'> /mnt/sdb/docker-file/jenkins/jenkins-en.Dockerfile
# docker build --network host -t upload.docker.sc.lan/devops/jenkins-en:2.235  --file=jenkins-en.Dockerfile .
FROM jenkins/jenkins:2.235.2-lts-centos7
USER root
RUN set -ex && \
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
    curl -jksSL -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo  && \
    yum clean all && yum makecache && \
    yum -y install epel-release && \
    yum -y install  sudo  libtool-ltdl  vim   && \
    yum clean all && \
    echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers   && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  && \
    touch /etc/profile.d/custom.sh && \
    echo "alias ll='ls -lrtFh --color=auto'" >> /etc/profile.d/custom.sh && \
    echo END_01

ENV MAVEN_HOME_ARG=/var/jenkins_home/maven/apache-maven-3.6.0

ENV MAVEN_HOME=${MAVEN_HOME_ARG} \
    PATH=${PATH}:${MAVEN_HOME_ARG}/bin 

RUN set -ex && \
    echo "export PATH=${PATH}" >> /etc/profile.d/custom.sh && \
    echo ${PATH} && \
    cat /etc/profile.d/custom.sh && \
    echo END_02

EOF

```
## 自定义java-centos镜像
容器发布的底层镜像
```dockerfile
cat <<'EOF'> /mnt/sdb/docker-file/java-centos/Dockerfile

# docker build -t upload.docker.sc.lan/devops/java-centos:1.8_201_b09 .
FROM centos:7.6.1810

# 下载地址 https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html
COPY java.tar.gz /tmp

# 下载地址 https://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html
COPY jce_policy-8.zip /tmp

# 中文字体文件 https://raw.githubusercontent.com/Sartner/docker-alpine-java/master/fonts/cjkuni-ukai.tar.gz
COPY cjkuni-ukai.tar.gz /tmp

# 中文字体文件 https://raw.githubusercontent.com/Sartner/docker-alpine-java/master/fonts/cjkuni-uming.tar.gz
COPY cjkuni-uming.tar.gz /tmp

# Java Version and other ENV
ENV JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    LANG=en_US.UTF-8 \
    IS_IN_CONTAINER=true

RUN set -ex && \
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
    curl -jksSL -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo  && \
    yum clean all && yum makecache && \
    echo "change yum" 

# Download and install jdk
RUN set -ex && \
    echo "---------- Update yum packages ----------" && \
    yum -y install epel-release && \
    yum -y install bind-utils openssh-clients telnet wget unzip less which nethogs sysstat net-tools iproute fontconfig mkfontscale sudo && \
    echo "---------- Install JDK ----------" && \
    tar -zxvf /tmp/java.tar.gz -C /opt && \
    ln -s /opt/jdk1.8.0_201 /opt/jdk && \
    cd /tmp && unzip /tmp/jce_policy-8.zip && \
    yes | cp -vf /tmp/UnlimitedJCEPolicyJDK8/*.jar /opt/jdk/jre/lib/security && \
    sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/jre/lib/security/java.security && \
    echo "---------- Custom changes ----------" && \
    cd /tmp && \
    # 调整线程上限
    sed -i "s/4096/1000000/g" /etc/security/limits.d/20-nproc.conf && \
    # JAVA_HOME Profile
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile.d/java.sh && \
    # sudo 保留环境变量
    echo "Defaults        env_keep=\"PATH JAVA_HOME\"" >> /etc/sudoers.d/env_keep && \
    sed -i "s/Defaults    secure_path/# Defaults    secure_path/g" /etc/sudoers && \
    echo "---------- Change timezone to Shanghai ----------" && \
    mv /etc/localtime /etc/localtime_bak && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "---------- Add chinese fonts ----------" && \
    tar -zxvf /tmp/cjkuni-ukai.tar.gz -C /usr/share/fonts/ && rm -rf /tmp/cjkuni-ukai.tar.gz && \
    tar -zxvf /tmp/cjkuni-uming.tar.gz -C /usr/share/fonts/ && rm -rf /tmp/cjkuni-uming.tar.gz && \
    mkfontscale && mkfontdir && fc-cache -vf && \
    echo "---------- Add custom user ----------" && \
    groupadd -g 667 ocean && \
    useradd -m ocean -u 667 -g 667 -s /sbin/nologin && \
    echo "---------- add profile ----------" && \
    touch /etc/profile.d/custom.sh && \
    echo "alias ll='ls -lrtFh --color=auto'" >> /etc/profile.d/custom.sh && \
    echo "export EDITOR=vim" >> /etc/profile.d/custom.sh && \
    echo "export TERM=xterm-color" >> /etc/profile.d/custom.sh && \
    echo "WHITE=\"\e[1;37m\";GREEN=\"\e[1;32m\";YELLOW=\"\e[1;33m\";BULE=\"\e[1;36m\";ORANGE_BG=\"\e[1;43m\";END=\"\e[m\";" >> /etc/profile.d/custom.sh && \
    echo "export PS1=\"\n\${WHITE}[container]\${END}\${GREEN}\u\${END}\${YELLOW}@\${END}\${BULE}\h\${END}:\w\n\\$ \"" >> /etc/profile.d/custom.sh && \
    echo "---------- delete tmp files ----------" && \
    yum clean all && \
    rm -rf /tmp/*

EOF

```
## 配置Jenkins开机启动
```bash
cat <<'EOF'> /etc/systemd/system/jenkins.sh
#!/bin/bash
docker run \
--name jenkins \
--restart always \
-v /mnt/sdb/jenkins_home:/var/jenkins_home \
-v /usr/bin/docker:/usr/bin/docker \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /root/.docker/config.json:/root/.docker/config.json \
-p 6080:8080 -p 50000:50000 \
-u root \
--env JENKINS_OPTS='--prefix=/jenkins' \
--env JAVA_OPTS='-Xms300m -Xmx300m -Duser.timezone=Asia/Shanghai -Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true' \
--add-host demo.k8s.com:127.0.0.1 \
upload.docker.sc.lan/devops/jenkins-en:2.235
EOF

cat <<'EOF'> /etc/systemd/system/jenkins.sh
[Unit]
Description=jenkins docker wrapper
Wants=docker.socket
After=docker.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/etc/systemd/system/jenkins.sh
ExecStartPre=-/usr/bin/docker rm -f jenkins
ExecStop=-/usr/bin/docker rm -f jenkins
Restart=always
RestartSec=15s
TimeoutStartSec=50s

[Install]
WantedBy=multi-user.target

EOF


# 开机自启动
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

```
## 添加反向代理配置
```bash
cat /etc/nginx/conf.d/jenkins.sc.lan.conf
server {
    listen 80;
    server_name jenkins.sc.lan;
    location / {
      proxy_pass http://127.0.0.1:6080;
			proxy_set_header X-Forwarded-Host $host:$server_port;
    	proxy_set_header X-Forwarded-Server $host;
    	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    	proxy_set_header X-Forwarded-Proto $scheme;
    	proxy_set_header X-Real-IP $remote_addr;
    }
}

EOF
```
## 配置Jenkins插件下载加速
```bash
1. Manage Jenkins ->  Manager Plugins -> Advanced -> Update Site 为
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
2. 点击check now
3. 更改宿主机配置文件 /mnt/sdb/jenkins_home/update/default.json
sed -i 's/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json && sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' default.json

4. docker restart jenkins
5. 安装一个插件测试速度
```
## 安装Jenkins插件
```bash
# Jenkins需要插件

Apache HttpComponents Client 4.x API Plugin
Authentication Tokens API Plugin
bouncycastle API Plugin
Build Timestamp Plugin
CloudBees Docker Build and Publish plugin
Command Agent Launcher Plugin
Conditional BuildStep
Credentials Binding Plugin
Credentials Plugin
Display URL API
Docker Commons Plugin
Extensible Choice Parameter plugin
Git client
Git Parameter Plug-In
Git plugin
Gitlab Hook Plugin
GitLab Plugin
jQuery plugin
JSch dependency plugin
JUnit
Mailer Plugin
Matrix Authorization Strategy Plugin
Matrix Project Plugin
Maven Integration plugin
Oracle Java SE Development Kit Installer Plugin
OWASP Markup Formatter Plugin
Pipeline: API
Pipeline: Job
Pipeline: SCM Step
Pipeline: Step API
Pipeline: Supporting APIs
Plain Credentials Plugin
ruby-runtime
Hosts runtime for enabling pure-Ruby plugins
Run Condition Plugin
SCM API Plugin
Script Security Plugin
SSH Credentials Plugin
Structs Plugin
Token Macro Plugin
Trilead API Plugin
WMI Windows Agents Plugin
```
