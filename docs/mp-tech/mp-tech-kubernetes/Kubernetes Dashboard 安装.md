# 版本信息
**Kubernetes: 1.18.6**

**Kubernetes Dashboard: 2.0.3**

**Metrics Server: 0.3.7**

# 安装 Kubernetes Dashboard
**官方地址：**[https://github.com/kubernetes/dashboard](https://github.com/kubernetes/dashboard)

按照官方文档 [Getting Started > Install](https://github.com/kubernetes/dashboard#getting-started) 中的安装方式进行安装

```bash
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.3/aio/deploy/recommended.yaml
kubectl apply -f ./recommended.yaml
```
# 添加 Cluster Admin 权限
安装完毕之后默认的权限是无法看到任何信息的，只能保证Dashbard的正常运行，所以这里我们需要自行添加权限。

**参考文档：**[Creating admin user to access Kubernetes dashboard](https://medium.com/@kanrangsan/creating-admin-user-to-access-kubernetes-dashboard-723d6c9764e4)

## 创建ServiceAccount并绑定管理员角色
我们创建一个新的ServiceAccount，并绑定到Kubernetes的默认管理员角色 `cluster-admin` 上
```bash
cat <<EOF> ./kubernetes-dashboard-admin.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kubernetes-dashboard-admin
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard-admin
  namespace: kubernetes-dashboard
EOF

kubectl -f ./kubernetes-dashboard-admin.yaml
```
## 获取Dashboard的登录token
```bash
kubectl -n kubernetes-dashboard describe secret kubernetes-dashboard-admin
```
命令输出以下信息，记录输出内容中Data区域里的token
```
Name:         kubernetes-dashboard-admin-token-7mfw2
Namespace:    kubernetes-dashboard
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: kubernetes-dashboard-admin
              kubernetes.io/service-account.uid: cc29a09e-ff17-4e4f-8b96-9b575fd0691e

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  20 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZZS......oBR5Cq5e0vYy_NrHFmWgyOCBExKD1HrgL7-mMKYTIw
```
# 安装 Metric Server
安装 Metrics Server 后可以让我们在 Dashboard 中看到Nodes、Pods的相关CPU、内存资源消耗情况

**官方地址：**[https://github.com/kubernetes-sigs/metrics-server](https://github.com/kubernetes-sigs/metrics-server)

## 下载Yaml
```bash
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
```
## 禁用TLS
由于我们使用的是自签名证书，直接启动会报错 x509: certificate signed by unknown authority

我们需要在metrics-server的启动参数中添加 --kubelet-insecure-tls          

```yaml
containers:
- name: metrics-server
  image: k8s.gcr.io/metrics-server/metrics-server:v0.3.7
  imagePullPolicy: IfNotPresent
  args:
    - --cert-dir=/tmp
    - --secure-port=4443
    - --kubelet-insecure-tls #<---------------------------添加到这里
  ports:
  - name: main-port
    containerPort: 4443
    protocol: TCP
```
## 部署
```bash
kubectl apply -f ./components.yaml
```
# 使用 Ingress 访问
官方使用 `kubectl proxy` 进行访问，不太方便。这里我们添加一条 Ingress 路由，使其可以通过指定域名进行访问。
## 创建自签名证书
由于 Dashboard 基于HTTPS，这里我们需要先创建自签名证书
```bash
# 创建自签名证书
$ openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout kubernetes-dashboard-tls.key -out kubernetes-dashboard-tls.crt -subj "/CN=dashboard.k8s.sc.lan"

# 将证书存储到 Kubernetes Secret 中
$ kubectl create secret generic kubernetes-dashboard-tls --from-file=kubernetes-dashboard-tls.crt --from-file=kubernetes-dashboard-tls.key -n kubernetes-dashboard
```
## **创建 Traefik Dashboard Ingress 路由规则 **
```bash
# 创建yaml
cat <<'EOF'> kubernetes-dashboard-ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: kubernetes-dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/ingress.class: traefik
    traefik.ingress.kubernetes.io/router.tls: "true"
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
spec:
  tls:
  - secretName: kubernetes-dashboard-tls
  rules:
  - host: dashboard.k8s.sc.lan
    http:
      paths:
      - path: /
        backend:
          serviceName: kubernetes-dashboard
          servicePort: 443
EOF

# 部署
kubectl apply -f kubernetes-dashboard-ingress.yaml
```
# 配置域名解析
可以通过如下方式进行：

- 使用DNS泛域名解析（解析所有k8s.sc.lan域名到某个IP，这样以后创建相同域的域名就不用反复添加了）
- 添加DNS配置
- 添加Hosts
# 访问 Dashboard
直接访问 [https://dashboard.k8s.sc.lan/#/node?namespace=default](https://dashboard.k8s.sc.lan/#/node?namespace=default)

通过 [获取Dashboard的登录token](#kTfVd) 步骤中的 token 进行登录即可

# 其他参考文档
[Kubernetes 部署 Ingress 控制器 Traefik v2.2](http://www.mydlq.club/article/72/)