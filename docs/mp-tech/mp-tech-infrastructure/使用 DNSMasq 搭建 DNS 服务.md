# 安装
在服务器上执行以下语句：
```bash
yum -y install dnsmasq
systemctl enable --now dnsmasq
```
# 服务配置
在服务器上执行以下语句：
```bash
cp /etc/resolv.conf /etc/dnsmasq.d/resolv.conf

# 备份默认配置
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.default

# 注释掉 conf-dir 配置
sed -i '/conf-dir=/s/^#*/#/g' /etc/dnsmasq.conf

# 加入自定义配置
cat <<'EOF'>> /etc/dnsmasq.conf

# ==================== 自定义 ====================
# 不将/etc/hosts中的映射关系加入到DNS规则中
no-hosts

# 缓存数量
cache-size=10240

# 修改resolv-file位置
resolv-file=/etc/dnsmasq.d/resolv.conf

# 自定义hosts位置
addn-hosts=/etc/dnsmasq.d/hosts

# 自定义 address 配置地址
conf-file=/etc/dnsmasq.d/address.conf
EOF

touch /etc/dnsmasq.d/address.conf
touch /etc/dnsmasq.d/hosts
```
# 配置域名解析
## 精确域名解析
配置精确域名解析，我么可以将一个或多个域名解析到某个IP上，也可以将某个域名指向多个IP

修改 `/etc/dnsmasq.d/hosts` 文件（格式参考 `/etc/hosts`），示例：

```
172.26.228.15 cluster-001.example.com cluster-001
```
## 泛域名解析
配置泛域名解析后，我们可以将某个域名下的所有子域名全部解析到某台服务器上
修改 `/etc/dnsmasq.d/address.conf` 文件，示例：

```bash
address=/example.com/172.26.228.21
```
这样我们所有 *.example.com 的IP地址都会解析到 172.26.228.21 上
# 配置完毕后重启 DNSMasq 服务
```bash
systemctl restart dnsmasq
```
# 修改服务器使用的 DNS
修改所有内网服务器上的 `/etc/resolv.conf` 中的 nameserver IP 地址，修改为 DNSMasq 的服务器IP地址
# 校验
查看 DNSMasq 服务状态是否正常
```bash
systemctl status dnsmasq
```
使用 `dig` 命令校验配置是否正确
```bash
dig example-001
dig 111.example.com
```
# 参考


[使用dnsmasq支持hosts泛解析与DNS加速](https://blog.ansheng.me/article/dnsmasq-hosts-pan-parsing-and-dns-acceleration.html)