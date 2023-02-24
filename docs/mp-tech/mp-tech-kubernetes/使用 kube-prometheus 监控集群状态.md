**官方地址： **[https://github.com/prometheus-operator/kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)

**kube-prometheus 版本: v0.6.0**

**Kubernetes 版本：1.18**

# 安装
## 下载 kube-prometheus 源码
```bash
wget https://github.com/prometheus-operator/kube-prometheus/archive/v0.6.0.zip
```
## 提取 manifests 文件
```bash
unzip v0.6.0.zip
mv kube-prometheus-0.6.0/manifests/ ./
```
## 修改 manifests 文件
### 使用代理仓库替换默认的 quay.io 加速镜像下载
由于我们在docker配置文件中配置了代理镜像仓库镜像，这里把所有镜像名称中的 `quay.io/` 都删掉，就可以直接使用代理仓库了
```bash
find ./manifests -type f -exec sed -i -e "s/ quay.io\// /g" {} \;
```
### 添加 prometheus 及 grafana 的 ingress 描述文件
#### prometheus-ingress.yaml
```bash
cat <<'EOF'> ./manifests/prometheus-ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: prometheus-k8s
  namespace: monitoring
  annotations:
    kubernetes.io/ingress.class: traefik
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
  - host: prometheus.k8s.sc.lan
    http:
      paths:
      - path: /
        backend:
          serviceName: prometheus-k8s
          servicePort: 9090
EOF
```
#### grafana-ingress.yaml
```bash
cat <<'EOF'> ./manifests/grafana-ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: grafana
  namespace: monitoring
  annotations:
    kubernetes.io/ingress.class: traefik
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
  - host: grafana.k8s.sc.lan
    http:
      paths:
      - path: /
        backend:
          serviceName: grafana
          servicePort: 3000
EOF
```
### 部署 manifests
```bash
kubectl apply -f ./manifests/setup/
kubectl apply -f ./manifests/
```
# 验证
在浏览器访问

- [http://prometheus.k8s.sc.lan/](http://prometheus.k8s.sc.lan/)
- [http://grafana.k8s.sc.lan/](http://grafana.k8s.sc.lan/) - 默认帐号密码 admin
# 参考文档
[使用 Prometheus Operator 监控 Kubernetes 集群](http://www.mydlq.club/article/10/#wow9)