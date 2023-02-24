# 一、环境准备
## 1.1、私有仓库搭建
在运行Docker镜像时，容器镜像需要从远端仓库拉取。在Docker的默认配置模式下，镜像是通过 Docker 官方提供的镜像仓库 Docker Hub 中获取。通常每个企业希望自己的代码及构建产物可以私有化存储，使用官方 Docker Hub 仓库并不能满足企业的安全以及性能需求。

Nexus3 是一套开源的仓库系统，支持包括 Maven、Python、Yum 等数十种仓库结构，这里我们可以使用 Nexus 搭建一套私有的企业级 Docker 镜像仓库。

[使用 Nexus3 搭建仓库服务](https://www.yuque.com/sartner/sd94ah/gfzeke)

# 二、安装
Docker 服务的安装可以产考Docker官方提供的安装文档。安装过程不需要其它额外的配置。

我们可以使用阿里云提供的Yum仓库源来加速 Docker 软件的下载、安装速度。

```bash
# 安装
yum install -y yum-utils device-mapper-persistent-data lvm2

# 设置阿里云源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum -y install docker-ce
systemctl enable docker
```
# 三、配置
Docker 服务安装完毕后，需要调整一下默认的Docker服务参数，比较重要的参数如下：

- **live-restore：**允许 Docker Daemon 重启时不杀死容器进程，方便Docker进行配置变更、重启等运维操作；
- **registry-mirrors：**私有镜像仓库地址，我们可以使用 Nexus3 搭建私有镜像仓库，代理 DockerHub 以及其它第三方镜像仓库（如：谷歌镜像仓库），加速第三方镜像下载速度；
- **insecure-registries：**非安全（HTTP）私有仓库地址。在安全模式下镜像仓库的通讯使用HTTPS进行，需要配置额外的CA证书，为了简化该步骤我们这里直接使用非安全模式；
- **storage-driver：**本地存储驱动，我们使用性能更好的 `overlay2` ；



**整体配置文件如下：**
```bash
# 修改配置
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "live-restore": true,
  "registry-mirrors": ["http://docker.sc.lan"],
  "insecure-registries" : ["docker.sc.lan","upload.docker.sc.lan"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker
```