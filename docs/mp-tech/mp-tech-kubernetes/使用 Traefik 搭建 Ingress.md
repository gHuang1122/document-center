# 版本信息
**Traefik: 2.2.7**

**Kubernetes: 1.18.6**

# 创建 CRD 资源
```bash
cat <<'EOF' > traefik-crd.yaml
## IngressRoute
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
name: ingressroutes.traefik.containo.us
spec:
scope: Namespaced
group: traefik.containo.us
version: v1alpha1
names:
kind: IngressRoute
plural: ingressroutes
singular: ingressroute
---
## IngressRouteTCP
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
name: ingressroutetcps.traefik.containo.us
spec:
scope: Namespaced
group: traefik.containo.us
version: v1alpha1
names:
kind: IngressRouteTCP
plural: ingressroutetcps
singular: ingressroutetcp
---
## Middleware
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
name: middlewares.traefik.containo.us
spec:
scope: Namespaced
group: traefik.containo.us
version: v1alpha1
names:
kind: Middleware
plural: middlewares
singular: middleware
---
## TLSOption
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
name: tlsoptions.traefik.containo.us
spec:
scope: Namespaced
group: traefik.containo.us
version: v1alpha1
names:
kind: TLSOption
plural: tlsoptions
singular: tlsoption
---
## TraefikService
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
name: traefikservices.traefik.containo.us
spec:
scope: Namespaced
group: traefik.containo.us
version: v1alpha1
names:
kind: TraefikService
plural: traefikservices
singular: traefikservice
---
## TLSStore
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
name: tlsstores.traefik.containo.us
spec:
group: traefik.containo.us
version: v1alpha1
names:
kind: TLSStore
plural: tlsstores
singular: tlsstore
scope: Namespaced
---
## IngressRouteUDP
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
name: ingressrouteudps.traefik.containo.us
spec:
group: traefik.containo.us
version: v1alpha1
names:
kind: IngressRouteUDP
plural: ingressrouteudps
singular: ingressrouteudp
scope: Namespaced
EOF

kubectl apply -f traefik-crd.yaml
```
# **创建 RBAC 权限**
```bash
cat <<'EOF' > traefik-rbac.yaml
## ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
namespace: kube-system
name: traefik-ingress-controller
---
## ClusterRole
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
name: traefik-ingress-controller
rules:
- apiGroups: [""]
resources: ["services","endpoints","secrets"]
verbs: ["get","list","watch"]
- apiGroups: ["extensions"]
resources: ["ingresses"]
verbs: ["get","list","watch"]
- apiGroups: ["extensions"]
resources: ["ingresses/status"]
verbs: ["update"]
- apiGroups: ["traefik.containo.us"]
resources: ["middlewares","ingressroutes","ingressroutetcps","tlsoptions","ingressrouteudps","traefikservices","tlsstores"]
verbs: ["get","list","watch"]
---
## ClusterRoleBinding
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
name: traefik-ingress-controller
roleRef:
apiGroup: rbac.authorization.k8s.io
kind: ClusterRole
name: traefik-ingress-controller
subjects:
- kind: ServiceAccount
name: traefik-ingress-controller
namespace: kube-system
EOF

kubectl apply -f traefik-rbac.yaml -n kube-system
```
# 创建 Traefik 配置文件
```bash
cat <<'EOF' > traefik-config.yaml
kind: ConfigMap
apiVersion: v1
metadata:
name: traefik-config
data:
traefik.yaml: |-
ping: "" ## 启用 Ping
serversTransport:
insecureSkipVerify: true ## Traefik 忽略验证代理服务的 TLS 证书
api:
insecure: true ## 允许 HTTP 方式访问 API
dashboard: true ## 启用 Dashboard
debug: false ## 启用 Debug 调试模式
metrics:
prometheus: "" ## 配置 Prometheus 监控指标数据，并使用默认配置
entryPoints:
web:
address: ":80" ## 配置 80 端口，并设置入口名称为 web
websecure:
address: ":443" ## 配置 443 端口，并设置入口名称为 websecure
providers:
kubernetesCRD: "" ## 启用 Kubernetes CRD 方式来配置路由规则
kubernetesIngress: "" ## 启动 Kubernetes Ingress 方式来配置路由规则
log:
filePath: "" ## 设置调试日志文件存储路径，如果为空则输出到控制台
level: error ## 设置调试日志级别
format: json ## 设置调试日志格式
accessLog:
filePath: "" ## 设置访问日志文件存储路径，如果为空则输出到控制台
format: json ## 设置访问调试日志格式
bufferingSize: 0 ## 设置访问日志缓存行数
filters:
#statusCodes: ["200"] ## 设置只保留指定状态码范围内的访问日志
retryAttempts: true ## 设置代理访问重试失败时，保留访问日志
minDuration: 20 ## 设置保留请求时间超过指定持续时间的访问日志
fields: ## 设置访问日志中的字段是否保留（keep 保留、drop 不保留）
defaultMode: keep ## 设置默认保留访问日志字段
names: ## 针对访问日志特别字段特别配置保留模式
ClientUsername: drop
headers: ## 设置 Header 中字段是否保留
defaultMode: keep ## 设置默认保留 Header 中字段
names: ## 针对 Header 中特别字段特别配置保留模式
User-Agent: redact
Authorization: drop
Content-Type: keep
#tracing: ## 链路追踪配置,支持 zipkin、datadog、jaeger、instana、haystack 等
# serviceName: ## 设置服务名称（在链路追踪端收集后显示的服务名）
# zipkin: ## zipkin配置
# sameSpan: true ## 是否启用 Zipkin SameSpan RPC 类型追踪方式
# id128Bit: true ## 是否启用 Zipkin 128bit 的跟踪 ID
# sampleRate: 0.1 ## 设置链路日志采样率（可以配置0.0到1.0之间的值）
# httpEndpoint: http://localhost:9411/api/v2/spans ## 配置 Zipkin Server 端点
EOF

kubectl apply -f traefik-config.yaml -n kube-system
```
# 给K8S节点设置标签
```bash
kubectl label nodes k8s-gateway-001.sc-host.lan IngressProxy=true
```
# 部署 Traefik
```bash
cat <<'EOF'> traefik-deploy.yaml
apiVersion: v1
kind: Service
metadata:
  name: traefik
spec:
  ports:
    - name: web
      port: 80
    - name: websecure
      port: 443
    - name: admin
      port: 8080
  selector:
    app: traefik
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: traefik-ingress-controller
  labels:
    app: traefik
spec:
  selector:
    matchLabels:
      app: traefik
  template:
    metadata:
      name: traefik
      labels:
        app: traefik
    spec:
      serviceAccountName: traefik-ingress-controller
      terminationGracePeriodSeconds: 1
      containers:
        - image: traefik:v2.2.7
          name: traefik-ingress-lb
          ports:
            - name: web
              containerPort: 80
              hostPort: 80         ## 将容器端口绑定所在服务器的 80 端口
            - name: websecure
              containerPort: 443
              hostPort: 443        ## 将容器端口绑定所在服务器的 443 端口
            - name: admin
              containerPort: 8080  ## Traefik Dashboard 端口
          resources:
            limits:
              cpu: 2000m
              memory: 1024Mi
            requests:
              cpu: 1000m
              memory: 1024Mi
          securityContext:
            capabilities:
              drop:
                - ALL
              add:
                - NET_BIND_SERVICE
          args:
            - --configfile=/config/traefik.yaml
          volumeMounts:
            - mountPath: "/config"
              name: "config"
          readinessProbe:
            httpGet:
              path: /ping
              port: 8080
            failureThreshold: 3
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 5
          livenessProbe:
            httpGet:
              path: /ping
              port: 8080
            failureThreshold: 3
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 5    
      volumes:
        - name: config
          configMap:
            name: traefik-config 
      tolerations:              ## 设置容忍所有污点，防止节点被设置污点
        - operator: "Exists"
      nodeSelector:             ## 设置node筛选器，在特定label的节点上启动
        IngressProxy: "true"
EOF

kubectl apply -f traefik-deploy.yaml -n kube-system
```
# 示例：使用 Traefik 路由 Kubernetes Dashboard
## 配置 Traefik Dashboard 路由规则
```bash
cat <<'EOF'> traefik-dashboard-ingress.yaml 
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: traefik-dashboard-ingress
  namespace: kube-system
  annotations:
    kubernetes.io/ingress.class: traefik            
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
  - host: traefik.k8s.sc.lan 
    http:
      paths:
      - path: /              
        backend:
          serviceName: traefik
          servicePort: 8080
EOF

kubectl apply -f traefik-dashboard-ingress.yaml 
```
## 添加 DNS 域名解析
**配置方式：**[https://www.yuque.com/sartner/sd94ah/nyl19t#sN0ZB](https://www.yuque.com/sartner/sd94ah/nyl19t#sN0ZB)
## 访问Traefik Dashboard
访问 [http://traefik.k8s.sc.lan/](http://traefik.k8s.sc.lan/)
# 示例：使用 Traefik 配置子路径路由
**目标：**将 http://helloworld-sub.stable.k8s.sc.lan/sub 的请求路由到指定service中，且目标服务URI为根路径

Traefik 2.0 以上版本只能使用 CRD 去配置该模式，配置方式如下：

```bash
cat <<'EOF'> traefik-ingress-subpath-example.yaml 
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: helloworld-sub.stable.k8s.sc.lan`
  namespace: bigdata
spec:
  entryPoints:
    - web
  routes:
    - match: Host(`helloworld-sub.stable.k8s.sc.lan`) && PathPrefix(`/sub`)
      kind: Rule
      services:
        - name: helloworld-11-stable
          port: 80
      middlewares:
        - name: sub-stripprefix
---
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: sub-stripprefix
  namespace: bigdata
spec:
  stripPrefix:
    prefixes:
      - /sub
EOF

kubectl apply -f traefik-ingress-subpath-example.yaml 
```
# 如何使用 Traefik 进行 TCP 路由
[https://docs.traefik.io/v2.2/routing/providers/kubernetes-crd/#kind-ingressroutetcp](https://docs.traefik.io/v2.2/routing/providers/kubernetes-crd/#kind-ingressroutetcp)
# 其他参考
[**Kubernetes 部署 Ingress 控制器 Traefik v2.2 · 小豆丁个人博客**](https://www.yuque.com/huangxin-kybsh/sd94ah/19fdbba0-b205-4f12-a4e8-27cf5ae8333c)