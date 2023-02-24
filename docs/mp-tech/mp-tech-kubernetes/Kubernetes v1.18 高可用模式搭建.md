# 安装Docker
参考：[https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker)
```bash
# 安装
yum install -y yum-utils device-mapper-persistent-data lvm2

# 设置阿里云源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum -y install docker-ce
systemctl enable docker


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
# 安装K8S组件
```bash
# 使用阿里云镜像源
cat <<EOF> /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum -y install kubernetes-cni-0.8.6-0.x86_64 kubectl-1.18.6-0.x86_64 kubelet-1.18.6-0.x86_64 kubeadm-1.18.6-0.x86_64

systemctl enable --now kubelet
```
# 安装Nginx反向代理
注意修改 `upstream kube_apiserver` 中的地址
```bash
cat <<'EOF'> /etc/systemd/system/kube-apiserver-proxy.service
[Unit]
Description=kube-apiserver-proxy docker wrapper
Wants=docker.socket
After=docker.service

[Service]
User=root
PermissionsStartOnly=true
ExecStart=/usr/bin/docker run \
                          -v /etc/kubernetes/apiserver-proxy.conf:/etc/nginx/nginx.conf \
                          --name kube-apiserver-proxy-systemd \
                          --net=host \
                          --restart=on-failure:5 \
                          --memory=512M \
                          nginx:1.19.1
ExecStartPre=-/usr/bin/docker rm -f kube-apiserver-proxy-systemd
ExecStop=/usr/bin/docker rm -rf kube-apiserver-proxy-systemd
ExecReload=/usr/bin/docker exec kube-apiserver-proxy-systemd nginx -s reload
Restart=always
RestartSec=15s
TimeoutStartSec=30s

[Install]
WantedBy=multi-user.target
EOF


mkdir -p /etc/kubernetes
cat <<'EOF'> /etc/kubernetes/apiserver-proxy.conf
error_log stderr notice;

worker_processes auto;
events {
    multi_accept on;
    use epoll;
    worker_connections 1024;
}

stream {
    upstream kube_apiserver {
        least_conn;
        # 后端为三台 master 节点的 apiserver 地址
        server 172.26.228.15:6443;
        server 172.26.228.16:6443;
        server 172.26.228.17:6443;
    }
    
    server {
        listen        0.0.0.0:8443;
        proxy_pass    kube_apiserver;
        proxy_timeout 10m;
        proxy_connect_timeout 1s;
    }
}
EOF

systemctl enable --now kube-apiserver-proxy
```


# 安装K8S
## 预下载镜像
```bash
# 如果docker配置了代理服务器则可以直接是用kubeadmin预下载镜像
# kubeadm config images pull

# 如果有其它源地址可以通过如下方式进行预下载
# list出镜像相关版本
# kubeadmin config images list

# 从第三方源站下载
docker pull docker.sc.lan/kube-apiserver:v1.18.6
docker pull docker.sc.lan/kube-controller-manager:v1.18.6
docker pull docker.sc.lan/kube-scheduler:v1.18.6
docker pull docker.sc.lan/kube-proxy:v1.18.6
docker pull docker.sc.lan/pause:3.2
docker pull docker.sc.lan/etcd:3.4.3-0
docker pull docker.sc.lan/coredns:1.6.7

# 重新打tag
docker tag docker.sc.lan/kube-apiserver:v1.18.6            k8s.gcr.io/kube-apiserver:v1.18.6
docker tag docker.sc.lan/kube-controller-manager:v1.18.6   k8s.gcr.io/kube-controller-manager:v1.18.6
docker tag docker.sc.lan/kube-scheduler:v1.18.6            k8s.gcr.io/kube-scheduler:v1.18.6
docker tag docker.sc.lan/kube-proxy:v1.18.6                k8s.gcr.io/kube-proxy:v1.18.6
docker tag docker.sc.lan/pause:3.2                         k8s.gcr.io/pause:3.2
docker tag docker.sc.lan/etcd:3.4.3-0                      k8s.gcr.io/etcd:3.4.3-0
docker tag docker.sc.lan/coredns:1.6.7                     k8s.gcr.io/coredns:1.6.7

# 使用docker rm删除第三方源站镜像（略）
docker rmi docker.sc.lan/kube-apiserver:v1.18.6
docker rmi docker.sc.lan/kube-controller-manager:v1.18.6
docker rmi docker.sc.lan/kube-scheduler:v1.18.6
docker rmi docker.sc.lan/kube-proxy:v1.18.6
docker rmi docker.sc.lan/pause:3.2
docker rmi docker.sc.lan/etcd:3.4.3-0
docker rmi docker.sc.lan/coredns:1.6.7
```


## 初始化集群(首次初始化)


```bash
# 可以添加 --dry-run 参数看看有没有报错
kubeadm init \
--kubernetes-version=v1.18.6 \
--pod-network-cidr=10.157.0.0/16 \
--service-cidr=10.158.0.0/16 \
--control-plane-endpoint=127.0.0.1:8443 \
--upload-certs
```


把最后的输出内容记下来，以后会用到


```bash
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 192.168.106.88:8443 --token hg7jvb.205phkvk7rw2tv5u \
    --discovery-token-ca-cert-hash sha256:9515ce6e7a8c5215d7e61a967934d196d80f5f4f187e460d21214022d0bd2913 \
    --control-plane --certificate-key 88aae4fe84d229654f02ea55299cc364cfc98b0bb54d139c20805d667098c63f

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.106.88:8443 --token hg7jvb.205phkvk7rw2tv5u \
    --discovery-token-ca-cert-hash sha256:9515ce6e7a8c5215d7e61a967934d196d80f5f4f187e460d21214022d0bd2913
```


## 初始化kubectl配置
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


# 安装容器网络


## 方案1：calico


```bash
wget https://docs.projectcalico.org/v3.8/manifests/calico.yaml

#该配置文件默认采用的Pod的IP地址为192.168.0.0/16，需要修改为集群初始化参数--pod-network-cidr中采用的值10.157.0.0/16
sed -i "s#192\.168\.0\.0/16#10\.157\.0\.0/16#" ./calico.yaml
kubectl apply -f calico.yaml

# 等待所有容器状态处于Running状态
watch -n 2 kubectl get pods -n kube-system -o wide

# 查看节点状态
kubectl get nodes -o wide
```


## 方案2：Flannel


```bash
# 下载配置
HTTPS_PROXY=http://myproxy:8118 wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# 调整 backend 为 host-gw
grep -A 35 ConfigMap kube-flannel.yml
kind: ConfigMap
apiVersion: v1
metadata:
  name: kube-flannel-cfg
  namespace: kube-system
  labels:
    tier: node
    app: flannel
data:
  cni-conf.json: |
    {
      "name": "cbr0",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "flannel",
          "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }
      ]
    }
  net-conf.json: |
    {
      "Network": "10.30.0.0/16",
      "Backend": {
        "Type": "host-gw"  <--------- 这里
      }
    }
```


# 安装其它主节点
## 初始化集群


这里我们使用 `kubeadm init` 命令最后输出结果中的 `join` 命令加入新的主节点


```
# 将新master加入集群
kubeadm join 192.168.106.88:8443 --token hg7jvb.205phkvk7rw2tv5u \
--discovery-token-ca-cert-hash sha256:9515ce6e7a8c5215d7e61a967934d196d80f5f4f187e460d21214022d0bd2913 \
--control-plane --certificate-key 88aae4fe84d229654f02ea55299cc364cfc98b0bb54d139c20805d667098c63f

# 初始化kubectl配置
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


# 安装工作节点
同样我们使用 `kubeadm init` 输出结果中提供的 `join` 命令加入worker节点
```bash
kubeadm join 192.168.106.88:8443 --token hg7jvb.205phkvk7rw2tv5u \
    --discovery-token-ca-cert-hash sha256:9515ce6e7a8c5215d7e61a967934d196d80f5f4f187e460d21214022d0bd2913
```
# Q & A
## K8S相关镜像下载不下来怎么办
修改 `/usr/lib/systemd/system/docker.service` 在 `[Service]` 块中添加代理配置
```
[Service]
Environment="HTTP_PROXY=http://192.168.106.1:8118/"
Environment="HTTPS_PROXY=http://192.168.106.1:8118/"
```


## 默认证书只有1年，如何续期
参考：[https://kubernetes.io/zh/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/](https://kubernetes.io/zh/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)
```bash
# 在所有master节点上执行
kubeadm alpha certs renew all
```


## kubeadm join 提示 token 过期
参考：[https://www.jianshu.com/p/a5e379638577](https://www.jianshu.com/p/a5e379638577)
```bash
[root@k8s-master-1 tmp]# kubeadm token create
W0723 14:39:32.584450  122300 configset.go:202] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
5mkta0.7a71kp8u7gir51zf <-------- 新token

[root@k8s-new-1 ~]# kubeadm join --token 5mkta0.7a71kp8u7gir51zf ......
```


# 其它参考文档
[https://blog.csdn.net/twingao/article/details/105382305](https://blog.csdn.net/twingao/article/details/105382305)

[https://mritd.me/2020/01/21/set-up-kuberntes-ha-cluster-by-kubeadm/](https://mritd.me/2020/01/21/set-up-kuberntes-ha-cluster-by-kubeadm/)

[https://developer.aliyun.com/article/763983](https://developer.aliyun.com/article/763983)