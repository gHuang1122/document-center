---



! 版权声明：本博客内容均均为原创, 每篇博文作为知识积累, 写博不易, 转载请注明出处。


**目录[-]**

---

**系统环境：**


- Traefik 版本：v2.2.4
- Kubernetes 版本：1.18.5



**参考地址：**


- [Traefik 2.2 官方文档](https://docs.traefik.io/v2.2/)
- [Traefik RCD 路由规则参考地址](https://docs.traefik.io/v2.2/routing/providers/kubernetes-crd/)
- [Traefik Ingress 路由规则参考地址](https://docs.traefik.io/v2.2/routing/providers/kubernetes-ingress/)



**示例部署文件：**


- 示例部署文件 Github 地址：[https://github.com/my-dlq/blog-example/tree/master/kubernetes/traefik-v2.2-deploy](https://github.com/my-dlq/blog-example/tree/master/kubernetes/traefik-v2.2-deploy)



## 一、Traefik 简介


Traefik 是一款开源的边缘路由器，它可以让发布服务变得轻松有趣。它代表您的系统接收请求，并找出负责处理这些请求的组件。与众不同之处在于，除了它的许多特性之外，它还可以自动为您的服务发现正确的配置。当 Traefik 检查您的基础设施时，它会发现相关信息，并发现哪个服务为哪个请求提供服务。


Traefik 与每个主要的集群技术都是原生兼容的，比如 Kubernetes、Docker、Docker Swarm、AWS、Mesos、Marathon 等等; 并且可以同时处理多个。(它甚至适用于运行在裸机上的遗留软件。) 使用 Traefik，不需要维护和同步单独的配置文件: 所有事情都是实时自动发生的 (没有重启，没有连接中断)。使用 Traefik，只需要花费时间开发和部署新功能到您的系统，而不是配置和维护其工作状态。


## 二、Kubernetes 部署 Traefik


Traefik 最新推出了 v2.2 版本，这里将 Traefik 升级到最新版本，简单的介绍了下如何在 Kubernetes 环境下安装 Traefik v2.2，下面将介绍如何在 Kubernetes 环境下部署并配置 Traefik v2.2。


当部署完 Traefik 后还需要创建外部访问 Kubernetes 内部应用的路由规则，Traefik 支持两种方式创建路由规则，一种是创建 Traefik 自定义 `Kubernetes CRD` 资源方式，还有一种是创建 `Kubernetes Ingress` 资源方式。


> 注意：这里 Traefik 是部署在 Kube-system Namespace 下，如果不想部署到配置的 Namespace，需要修改下面部署文件中的 Namespace 参数。



### 1、创建 CRD 资源


在 `Traefik v2.0` 版本后，开始使用 `CRD`（Custom Resource Definition）来完成路由配置等，所以需要提前创建 `CRD` 资源。


****#** 创建 traefik-crd.yaml 文件 **


```

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
```


****#** 创建 Traefik CRD 资源 **


```
$ kubectl apply -f traefik-crd.yaml
```


### 2、创建 RBAC 权限


Kubernetes 在 1.6 版本中引入了基于角色的访问控制（RBAC）策略，方便对 `Kubernetes` 资源和 `API` 进行细粒度控制。`Traefik` 需要一定的权限，所以，这里提前创建好 `Traefik ServiceAccount` 并分配一定的权限。


**# 创建 traefik-rbac.yaml 文件:**


```

apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: kube-system
  name: traefik-ingress-controller
---

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
```


****#** 创建 Traefik RBAC 资源 **


- -n：指定部署的 Namespace



```
$ kubectl apply -f traefik-rbac.yaml -n kube-system
```


### 3、创建 Traefik 配置文件


由于 Traefik 配置很多，通过 `CLI` 定义不是很方便，一般时候都会通过配置文件配置 `Traefik` 参数，然后存入 `ConfigMap`，将其挂入 `Traefik` 中。


****#** 创建 traefik-config.yaml 文件 **


> 下面配置中可以通过配置 kubernetesCRD 与 kubernetesIngress 两项参数，让 Traefik 支持 CRD 与 Ingress 两种路由方式。



```
kind: ConfigMap
apiVersion: v1
metadata:
  name: traefik-config
data:
  traefik.yaml: |-
    ping: ""                    
    serversTransport:
      insecureSkipVerify: true  
    api:
      insecure: true            
      dashboard: true           
      debug: false              
    metrics:
      prometheus: ""            
    entryPoints:
      web:
        address: ":80"          
      websecure:
        address: ":443"         
    providers:
      kubernetesCRD: ""         
      kubernetesIngress: ""     
    log:
      filePath: ""              
      level: error              
      format: json              
    accessLog:
      filePath: ""              
      format: json              
      bufferingSize: 0          
      filters:
        
        retryAttempts: true     
        minDuration: 20         
      fields:                   
        defaultMode: keep       
        names:                  
          ClientUsername: drop  
        headers:                
          defaultMode: keep     
          names:                
            User-Agent: redact
            Authorization: drop
            Content-Type: keep
```


****#** 创建 Traefik ConfigMap 资源 **


- -n： 指定程序启的 Namespace



```
$ kubectl apply -f traefik-config.yaml -n kube-system
```


### 4、节点设置 Label 标签


由于是 `Kubernetes DeamonSet` 这种方式部署 `Traefik`，所以需要提前给节点设置 `Label`，这样当程序部署时会自动调度到设置 `Label` 的节点上。


****#** 节点设置 Label 标签 **


- 格式：kubectl label nodes [节点名] [key=value]



```
$ kubectl label nodes k8s-node-2-12 IngressProxy=true
```


****#** 查看节点是否设置 Label 成功 **


```
$ kubectl get nodes --show-labels

NAME            STATUS ROLES  VERSION  LABELS
k8s-master-2-11 Ready  master  v1.18.5  kubernetes.io/hostname=k8s-master-2-11,node-role.kubernetes.io/master=
k8s-node-2-12   Ready  <none> v1.18.5  kubernetes.io/hostname=k8s-node-2-12,IngressProxy=true
k8s-node-2-13   Ready  <none> v1.18.5  kubernetes.io/hostname=k8s-node-2-13
k8s-node-2-14   Ready  <none> v1.18.5  kubernetes.io/hostname=k8s-node-2-14
```


> 如果想删除标签，可以使用 “kubectl label nodes k8s-node-2-12 IngressProxy-” 命令



### 5、Kubernetes 部署 Traefik


下面将用 `DaemonSet` 方式部署 `Traefik`，便于在多服务器间扩展，用 `hostport` 方式绑定服务器 `80`、`443` 端口，方便流量通过物理机进入 `Kubernetes` 内部。


****#** 创建 traefik 部署 traefik-deploy.yaml 文件 **


```
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
        - image: traefik:v2.2.4
          name: traefik-ingress-lb
          ports:
            - name: web
              containerPort: 80
              hostPort: 80         
            - name: websecure
              containerPort: 443
              hostPort: 443        
            - name: admin
              containerPort: 8080  
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
      tolerations:              
        - operator: "Exists"
      nodeSelector:             
        IngressProxy: "true"
```


****#** Kubernetes 部署 Traefik**


```
$ kubectl apply -f traefik-deploy.yaml -n kube-system
```


到此 Traefik v2.2 应用已经部署完成。


## 三、配置路由规则


Traefik 应用已经部署完成，但是想让外部访问 `Kubernetes` 内部服务，还需要配置路由规则，上面部署 `Traefik` 时开启了 `Traefik Dashboard`，这是 `Traefik` 提供的视图看板，所以，首先配置基于 `HTTP` 的 `Traefik Dashboard` 路由规则，使外部能够访问 `Traefik Dashboard`。然后，再配置基于 `HTTPS` 的 `Kubernetes Dashboard` 的路由规则，这里分别使用 `CRD` 和 `Ingress` 两种方式进行演示。


### 1、方式一：使用 CRD 方式配置 Traefik 路由规则


> 使用 CRD 方式创建路由规则可言参考 Traefik 文档 [Kubernetes IngressRoute](https://docs.traefik.io/v2.2/routing/providers/kubernetes-crd/)



#### (1)、配置 HTTP 路由规则 （Traefik Dashboard 为例）


****#** 创建 Traefik Dashboard 路由规则 traefik-dashboard-route.yaml 文件 **


```
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard-route
spec:
  entryPoints:
  - web
  routes:
  - match: Host(`traefik.mydlq.club`)
    kind: Rule
    services:
      - name: traefik
        port: 8080
```


****#** 创建 Traefik Dashboard 路由规则对象 **


```
$ kubectl apply -f traefik-dashboard-route.yaml -n kube-system
```


#### (2)、配置 HTTPS 路由规则（Kubernetes Dashboard 为例）


这里我们创建 `Kubernetes` 的 `Dashboard` 看板创建路由规则，它是 `Https` 协议方式，由于它是需要使用 Https 请求，所以我们配置基于 Https 的路由规则并指定证书。


****#** 创建私有证书 tls.key、tls.crt 文件 **


```

$ openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=cloud.mydlq.club"


$ kubectl create secret generic cloud-mydlq-tls --from-file=tls.crt --from-file=tls.key -n kube-system
```


****#** 创建 Traefik Dashboard CRD 路由规则 kubernetes-dashboard-route.yaml 文件 **


```
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: kubernetes-dashboard-route
spec:
  entryPoints:
  - websecure
  tls:
    secretName: cloud-mydlq-tls
  routes:
  - match: Host(`cloud.mydlq.club`) 
    kind: Rule
    services:
      - name: kubernetes-dashboard
        port: 443
```


****#** 创建 Kubernetes Dashboard 路由规则对象 **


```
$ kubectl apply -f kubernetes-dashboard-route.yaml -n kube-system
```


### 2、方式二：使用 Ingress 方式配置 Traefik 路由规则


> 使用 Ingress 方式创建路由规则可言参考 Traefik 文档 [Kubernetes Ingress](https://docs.traefik.io/v2.2/routing/providers/kubernetes-ingress/)



#### (1)、配置 HTTP 路由规则 （Traefik Dashboard 为例）


****#** 创建 Traefik Ingress 路由规则 traefik-dashboard-ingress.yaml 文件 **


```
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
  - host: traefik.mydlq.club                                 
    http:
      paths:
      - path: /              
        backend:
          serviceName: traefik
          servicePort: 8080
```


****#** 创建 Traefik Dashboard Ingress 路由规则对象 **


```
$ kubectl apply -f traefik-dashboard-ingress.yaml -n kube-system
```


#### (2)、配置 HTTPS 路由规则（Kubernetes Dashboard 为例）


跟上面以 `CRD` 方式创建路由规则一样，也需要创建使用证书，然后再以 `Ingress` 方式创建路由规则。


****#** 创建私有证书 tls.key、tls.crt 文件 **


```

$ openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=cloud.mydlq.club"


$ kubectl create secret generic cloud-mydlq-tls --from-file=tls.crt --from-file=tls.key -n kube-system
```


****#** 创建 Traefik Dashboard Ingress 路由规则 kubernetes-dashboard-ingress.yaml 文件 **


```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: kubernetes-dashboard-ingress
  namespace: kube-system
  annotations:
    kubernetes.io/ingress.class: traefik                  
    traefik.ingress.kubernetes.io/router.tls: "true"
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
spec:
  tls:
  - secretName: cloud-mydlq-tls
  rules:
  - host: cloud.mydlq.club                               
    http:
      paths:
      - path: /                                     
        backend:
          serviceName: kubernetes-dashboard
          servicePort: 443
```


****#** 创建 Traefik Dashboard 路由规则对象 **


```
$ kubectl apply -f kubernetes-dashboard-ingress.yaml -n kube-system
```


## 四、方式创建路由规则后的应用


### 1、配置 Host 文件


客户端想通过域名访问服务，必须要进行 `DNS` 解析，由于这里没有 `DNS` 服务器进行域名解析，所以修改 `hosts` 文件将 `Traefik` 所在节点服务器的 `IP` 和自定义 `Host` 绑定。打开电脑的 `Hosts` 配置文件，往其加入下面配置：


```
192.168.2.12  traefik.mydlq.club
192.168.2.12  cloud.mydlq.club
```


### 2、访问对应应用


****#** 访问 Traefik Dashboard**


打开浏览器输入地址：[http://**traefik**.mydlq.club](http://**traefik**.mydlq.club) 打开 Traefik Dashboard。


[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/kubernetes-traefik2.2-1002.png?x-oss-process=style/shuiyin#alt=)
](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/kubernetes-traefik2.2-1002.png?x-oss-process=style/shuiyin)


****#** 访问 Traefik Dashboard**


打开浏览器输入地址：[https://**cloud**.mydlq.club](https://**cloud**.mydlq.club) 打开 Dashboard Dashboard。


[![](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/kubernetes-traefik2.2-1003.png?x-oss-process=style/shuiyin#alt=)
](https://mydlq-club.oss-cn-beijing.aliyuncs.com/images/kubernetes-traefik2.2-1003.png?x-oss-process=style/shuiyin)


到此文章结束，可以访问我的 Github 下载 [部署文件](https://github.com/my-dlq/blog-example/tree/master/kubernetes/traefik-v2.2-deploy)，别忘点颗 Start！！


—End—
[http://www.mydlq.club/article/72/#wow9](http://www.mydlq.club/article/72/#wow9)
