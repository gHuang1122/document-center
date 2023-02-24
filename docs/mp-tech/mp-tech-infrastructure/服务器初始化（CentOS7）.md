# 修改主机名
```bash
hostnamectl set-hostname <new-host-name>
```
# 修改系统参数
## 共有部分
注意修改DNS地址
```bash
############ 修改DNS ############
# 改成自己搭建的DNS服务器
cat <<'EOF'> /etc/resolv.conf
options timeout:2 attempts:3 rotate single-request-reopen
nameserver 172.26.228.14
EOF

############ 安装基础工具 ############
yum -y install telnet bind-utils vim net-tools lrzsz

############ limits 相关 ############
# 扩大句柄数
sed -i 's/4096/1000000/g' /etc/security/limits.d/20-nproc.conf

cat <<EOF>> /etc/security/limits.d/20-all-users.conf
*               soft    nproc          1000000
*               hard    nproc          1000000
*               soft    nofile         1000000
*               hard    nofile         1000000
EOF

############ 内核参数 ############
cat <<'EOF'> /etc/sysctl.d/50-custom.conf 
# 禁用IPV6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# 最大进程数量
kernel.pid_max = 1048576

# 进程可以拥有的VMA(虚拟内存区域)的数量
vm.max_map_count = 262144

#关闭tcp的连接传输的慢启动，即先休止一段时间，再初始化拥塞窗口。
net.ipv4.tcp_slow_start_after_idle = 0

# 哈希表项最大值，解决 'nf_conntrack: table full, dropping packet.' 问题
net.netfilter.nf_conntrack_max = 2097152

# 在指定之间（秒）内，已经建立的连接如果没有活动，则通过iptables进行清除。
net.netfilter.nf_conntrack_tcp_timeout_established = 1200

EOF


############ 关闭selinux ############
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
setenforce 0

############ 关闭防火墙 ############
systemctl disable firewalld
systemctl stop firewalld

########## 设置时间同步服务器 ##########
cat <<'EOF'> /etc/chrony.conf
# Use Alibaba NTP server
# Public NTP
# Alicloud NTP


server ntp.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp1.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp1.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp10.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp11.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp12.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp2.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp2.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp3.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp3.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp4.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp4.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp5.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp5.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp6.aliyun.com minpoll 4 maxpoll 10 iburst
server ntp6.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp7.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp8.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst
server ntp9.cloud.aliyuncs.com minpoll 4 maxpoll 10 iburst

# Ignore stratum in source selection.
stratumweight 0.05

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Enable kernel RTC synchronization.
rtcsync

# In first three updates step the system clock instead of slew
# if the adjustment is larger than 10 seconds.
makestep 10 3

# Allow NTP client access from local network.
#allow 192.168/16

# Listen for commands only on localhost.
bindcmdaddress 127.0.0.1
bindcmdaddress ::1

# Disable logging of client accesses.
noclientlog

# Send a message to syslog if a clock adjustment is larger than 0.5 seconds.
logchange 0.5

logdir /var/log/chrony
#log measurements statistics tracking
EOF
```
## 云主机环境
### 阿里云
```bash
# 阿里云的ECS会自动修改DNS配置，每次重启后会被还原
# 所以我们修改完毕后使用本命令锁定该文件，不允许修改。如需解锁将参数改成 -i 即可
chattr +i /etc/resolv.conf

# 阿里云的ECS在初始化时会在/etc/security/limits.conf文件的 # End of file 后添加如下配置
# root soft nofile 65535
# root hard nofile 65535
# * soft nofile 65535
# * hard nofile 65535
# 这些配置我们在共有部分已经配置过了，这里不再需要，直接干掉这几行
sed -i '0,/# End of file/!d' /etc/security/limits.conf

# 阿里云每次服务器自动重启之后会将ECS实例ID放入HOSTS中，这样会导致有些服务的服务器名称解析异常
# 这里我们把/etc/hosts中的内容清空，并锁定该文件
cat <<'EOF'> /etc/hosts
::1     localhost       localhost.localdomain   localhost6      localhost6.localdomain6
127.0.0.1       localhost       localhost.localdomain   localhost4      localhost4.localdomain4

EOF
chattr +i /etc/hosts
```
## Kubernetes 节点相关参数
```bash
##### 修改网络参数 #####
cat <<EOF> /etc/sysctl.d/99-kubernetes-cri.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p
modprobe overlay
modprobe br_netfilter
sysctl --system

# 关闭swap
sed  -i '/swap/ s/^#*/#/' /etc/fstab
swapoff -a
```
# 重启服务器
```bash
reboot
```
# 阿里云安全组设置
云服务器ECS > 网络与安全 > 安全组 > 进入安全组 > 手动添加

![image.png](./img/服务器初始化/image1.png)

