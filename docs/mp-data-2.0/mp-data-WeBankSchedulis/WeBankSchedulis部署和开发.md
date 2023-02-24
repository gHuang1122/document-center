# Schedulis 环境文档
## 一、Schedulis 普通版环境部署准备 

### 一）、使用前置

1. 请基于 Linux 操作系统操作（建议 CentOS）
2. 创建新用户 hadoop， 并为该用户赋予 root 权限,用于部署schedulis
3. 准备好 MySQL（版本5.5+） 的客户端和服务端
4. 请确保已安装并且正确配置 JDK（版本1.8+）
5. 配置集群各节点之间的免密码登录
6. 请准备一台已经正确安装和配置 Maven（版本3.3+） 和 Git 的机器，用来编译代码

### 二）、获取项目文件并编译打包

1. 使用 Git 下载 Schedulis 项目文件 git clone https://github.com/WeBankFinTech/Schedulis.git
2. 下载jobtype插件的依赖和配置，链接: https://pan.baidu.com/s/1pKOjY6tgNkRD5rVmvU0RXg 提取码: wy7r ；（由于文件大小较大，所以放在网盘进行管理）
3. 进入项目文件的根目录下，将第二步中下载的jobtypes文件解压后，将整个jobtypes文件夹放入项目module（azkaban-jobtyope）的根目录，然后使用 Maven 来编译打包整个项目 ```mvn clean install -Dmaven.test.skip=true```    
待整个项目编译打包成功后，用户可以在这两个服务(azkaban-web-server 和 azkaban-exec-server)各自的 target 目录下找到相应的 .ZIP 安装包(schedulis_***_web.zip 和 schedulis_***_exec.zip)。<font color="red">这里需要注意：打包完成后一定要确认安装包内是否有plugins目录，如发现安装包没有plugins，或者plugins为空，则分别进入 WebServer 和 ExecServer 目录，为它们单独再次编译即可,如果没有打包进来则无法使用插件</font>。

4. 将以下文件复制到需要部署的 Executor 或者 WebServer 服务器:    
    - Executor 或者 WebServer 安装包 
    - 项目文件根目录下的 bin/construct 目录中的数据库初始化脚本 hdp\_wtss\_deploy\_script.sql    
    - 项目文件根目录下的 bin 目录中的环境检测脚本 checkEnv.sh
5. 将安装包解压到合适的安装目录下，譬如：/appcom/Install/AzkabanInstall， 并将安装的根目录 /appcom 以及其下子目录的属主转换为 hadoop 用户， 且赋予 775 权限（/appcom/Install/AzkabnaInstall/ 为默认安装目录，建议创建该路径并将其作为安装路径，可避免一些路径的修改）
6. 在开始下一步操作之前，为需要部署的机器运行 bin 目录下的环境检测脚本 checkEnv.sh，确认基础环境已经准备完成。若是报错，请用户参考"使用前置"章节为部署节点准备好基础环境

### 三）、修改配置

### 1. 修改 host.properties 文件
此配置文件存放的路径请参考或者修改 ExecServer 安装包下的 bin/internal/internal-start-executor.sh 文件中的 KEY 值 hostConf     
该文件记录的是 Executor 端的所有执行节点 Hostname 和 ServerId， 需保持每台执行机器上的该文件内容一致

示例：

```shell
vi /appcom/config/wtss-config/host.properties
```
文件内容如下：    
```
executor1_hostname=1
executor2_hostname=2
executor3_hostname=3
```

其中executor1_hostname，executor2_hostname，executor3_hostname 为Executor节点所在机器的真实主机名。

### 2. 初始化数据库
在 MySQL 中相应的 database 中（也可新建一个），将前面复制过来的数据库初始化脚本导入数据库  

```
#连接 MySQL 服务端
#eg: mysql -uroot -p12345，其中，username ： root, password: 12345

mysql -uUserName -pPassword -hIP --default-character-set=utf8
```
```
#创建一个 Database(按需执行)

mysql> create database schedulis;
mysql> use schedulis; 
```
```
# 初始化 Database
#eg: source hdp_wtss_deploy_script.sql

mysql> source 脚本存放目录/hdp_wtss_deploy_script.sql
```
### 3. Executor Server 配置修改

#### 执行包修改

项目文件根目录下的 bin/construct 目录中任务执行依赖的包 execute-as-user ，复制到azkaban-exec-server的lib下，并且更新权限
```
sudo chown root execute-as-user
sudo chmod 6050 execute-as-user
```


#### plugins/jobtypes/commonprivate.properties

此配置文件存放于 ExecServer 安装包下的 plugins/jobtypes 目录下   
此配置文件主要设置程序启动所需要加载的一些 lib 和 classpath

```
#以下四项配置指向对应组件的安装目录，请将它们修改成相应的组件安装目录
hadoop.home=/appcom/Install/hadoop
hadoop.conf.dir=/appcom/config/hadoop-config
hive.home=/appcom/Install/hive
spark.home=/appcom/Install/spark

#azkaban.native.lib 请修改成ExecServer 安装目录下 lib 的所在绝对路径
execute.as.user=true
azkaban.native.lib=/appcom/Install/AzkabanInstall/wtss-exec/lib

```


#### plugins/jobtypes/common.properties

此配置文件存放于 ExecServer 安装包下的 plugins/jobtypes 目录下    
此配置文件主要是设置 DataChecker 和 EventChecker 插件的数据库地址，如不需要这两个插件可不用配置
```
#配置集群 Hive 的元数据库（密码用 base64 加密）
job.datachecker.jdo.option.name="job"
job.datachecker.jdo.option.url=jdbc:mysql://host:3306/db_name?useUnicode=true&amp;characterEncoding=UTF-8
job.datachecker.jdo.option.username=username
job.datachecker.jdo.option.password=password

#配置 Schedulis 的数据库地址（密码用 base64 加密）
msg.eventchecker.jdo.option.name="msg"
msg.eventchecker.jdo.option.url=jdbc:mysql://host:3306/db_name?useUnicode=true&characterEncoding=UTF-8
msg.eventchecker.jdo.option.username=username
msg.eventchecker.jdo.option.password=password


#此部分依赖于第三方脱敏服务mask，暂未开源，将配置写为和job类型一样即可（密码用 base64 加密） 

bdp.datachecker.jdo.option.name="bdp"
bdp.datachecker.jdo.option.url=jdbc:mysql://host:3306/db_name?useUnicode=true&amp;characterEncoding=UTF-8
bdp.datachecker.jdo.option.username=username
bdp.datachecker.jdo.option.password=password


```

#### conf/azkaban.properties

此配置文件是 ExecServer 的核心配置文件， 该配置文件存放在 ExecServer 安装包下的 conf 目录下    

```
#项目 MySQL 服务端地址（密码用 base64 加密）
mysql.port=3306
mysql.port=3306
mysql.host=localhost
mysql.database=schedulis
mysql.user=root
mysql.password=MTIzNDU2  # 123456 base64 加密
mysql.numconnections=100

#Executor 线程相关配置
executor.maxThreads=60
executor.port=12321
executor.flow.threads=30
jetty.headerBufferSize=65536
flow.num.job.threads=30
#此 server id 请参考1的 host.properties，改配置会在服务启动的时候自动从host.properties中拉取
executor.server.id=8
checkers.num.threads=200

#Web Sever url相关配置， eg: http://localhost:8081
azkaban.webserver.url=http://webserver_ip:webserver_port

```


#### plugins/alerter/WeBankIMS/conf/plugin.properties

此配置文件存放在 ExecServer 安装包下的 plugins/alerter/WeBankIMS/conf 目录下    
该配置文件主要是设置 Executor 告警插件地址， 请用户基于自己公司的告警系统来设置    
此部分依赖于第三方告警服务，如不需要可跳过配置
```
# webank alerter settings
alert.type=WeBankAlerter
alarm.server=ims_ip
alarm.port=10812
alarm.subSystemID=5003
alarm.alertTitle=WTSS Aleter Message
alarm.alerterWay=1,2,3
alarm.reciver=root
alarm.toEcc=0
```


#### conf/global.properties

该配置文件存放在 ExecServer 安装包下的 conf 目录下，该配置文件主要存放一些 Executor 的全局属性
```
#azkaban.native.lib，执行项目的 lib 目录，请修改成本机解压后的 ExecServer 安装包下 lib 的所在路径
execute.as.user=true
azkaban.native.lib=/appcom/Install/AzkabanInstall/wtss-exec/lib

```

#### plugins/jobtypes/linkis/private.properties

该配置文件存放在 ExecServer 安装包下的 plugins/jobtypes/linkis 目录下，主要是设置 jobtype 所需的 lib 所在位置
```
#将该值修改为 ExecServer 安装包目录下的 /plugins/jobtypes/linkis/extlib
jobtype.lib.dir=/appcom/Install/AzkabanInstall/wtss-exec/plugins/jobtypes/linkis/extlib
```


#### plugins/jobtypes/linkis/plugin.properties （按需修改）

若用户安装了 Linkis，则修改此配置文件来对接 Linkis，该配置文件存放在 ExecServer 安装包下的 plugins/jobtypes/linkis 目录下
```
#将该值修改为 Linkis 的gateway地址
wds.linkis.gateway.url=
```

### 4. Web Server 配置文件


#### conf/azkaban.properties

此配置文件是 WebServer 的核心配置文件， 该配置文件存放在 WebServer 安装包下的 conf 目录下

```
#项目 MySQL 配置（密码用 base64 加密）
database.type=mysql
mysql.port=
mysql.host=
mysql.database=
mysql.user=
mysql.password=
mysql.numconnections=100

#Azkaban jetty server properties  端口号需要和 azkaban.webserver.url 端口一致
jetty.port=8081

#Executor 选择策略配置
azkaban.use.multiple.executors=true
azkaban.executorselector.filters=StaticRemainingFlowSize
azkaban.queueprocessing.enabled=true
azkaban.webserver.queue.size=100000
azkaban.activeexecutor.refresh.milisecinterval=50000
azkaban.activeexecutor.refresh.flowinterval=5
azkaban.executorinfo.refresh.maxThreads=5
azkaban.executorselector.comparator.Memory=3
#azkaban.executorselector.comparator.CpuUsage=2
azkaban.executorselector.comparator.LastDispatched=1
azkaban.executorselector.comparator.NumberOfAssignedFlowComparator=1

# LDAP 地址配置
ladp.ip=ldap_ip
ladp.port=ldap_port
```

### 5. 修改日志存放目录（按需修改）
Schedulis 项目的日志默认存放路径为 /appcom/logs/azkaban, 目录下存放的就是 Executor 和 Web 两个服务相关的日志   
若选择使用默认存放路径，则需要按要求将所需路径提前创建出来， 并将文件属主转换为 hadoop，赋予 775 权限；若要使用自定义的日志存放路径，则需要创建好自定义路径，并修改 ExecServer 和 WebServer 安装包的以下文件：  
1. Executor 下的 bin/internal/internal-start-executor.sh 和 Web 下的 bin/internal/internal-start-web.sh 文件中的 KEY 值 logFile， 设为自定义日志存放路径, 以及在两个文件中关于 “Set the log4j configuration file” 中的 -Dlog4j.log.dir 也修改为自定义的日志路径 
2. 两个服务中的 bin/internal/util.sh 文件中的 KEY 值 shutdownFile，改为自定义日志路径

***

### 四）、启动
对数据库进行初始化完毕，以及修改完以上的配置文件后，就可以启动了
1. 进入 ExecutorServer 安装包路径，注意不要进到 bin 目录下
```shell
./bin/start-exec.sh
```
2. 进入 WebServer 安装包路径，注意不要进到 bin 目录下
```shell
./bin/start-web.sh
```
此时若得到提示信息说启动成功，则可以进入验证环节了；若是出错，请查看日志文件，并按需先查看 QA 章节

### 五）、测试
1. 若是单 WebServer 部署模式，则在浏览器中输入 http://webserver_ip:webserver_port    eg: http://localhost:8081
3. 在跳出的登陆界面输入默认的用户名和密码    
username : superadmin    
pwd : Abcd1234    
4. 成功登陆后，请参考用户使用手册，自己创建一个项目并上传测试运行
5. 运行成功，恭喜 Schedulis 成功安装了

## 二、QA 环节
1. 如何查看自己本机 Hostname ?   
命令行输入  ```hostname```

2. 为什么先启动了 Webserver 再启动 Executorserver，没有报错，但在浏览器连接时却提示无法连接？       
可以使用 Jps 命令确认 Webserver 进程是否启动了。一般情况下，建议先启动 ExecutorServer，再 WebServer。否则有可能 WebServer 先启动又被关掉。

3. 两个服务关于 MySQL 的配置中密码已经使用了 base64 加密，日志中还是无法提示连接 MySQL?    
请注意区分 Linux 下的 base64 加密与 Java base64 加密，我们使用的是后者。

4. 两个服务使用相应的 shutdown 脚本总是提示找不到相应的 Pid?    
若要关闭两个服务的话，请手动 Kill 掉相应的进程，并删除相应的 currentpid 文件。

5. 怎么重启服务？    
请参考4，将服务关闭再将服务开启。

6. 为什么 ExecutorServer 显示 Connection Failed，而修改配置后再启动，却提示 Already Started?    
此处请先将相应的 currentpid 文件删除，再重新启动。

7. 为什么报错了，相应的日志文件没有更新？    
请先确认配置的日志文件路径是否正确，再将日志文件属主修改为 hadoop 用户，并赋予 775 权限。

8. 上传项目文件后，系统报错？    
请确认 WebServer 安装包路径的 lib 目录下是否存在 common-lang3.jar，若没有请手动添加。

9. 为什么报错了，却找不到相应的日志文件？    
请确认已经正确配置日志文件路径。详情请参考参数配置中的修改日志存放路径。

10. 为什么在 Maven 编译的时候会出现 systemPath 不是绝对路径？     
首先确认是否已经设置了 MAVEN_HOME 的环境变量，并且确认是否已经刷新环境变量文件           
若是上面步骤都已完成，可以在编译的时候传入参数      
```mvn install -Denv.MAVEN_HOME=dir of local repository set in settings.xml```

11. 编译时出现错误 “Could not find artifactor xxx”?     
请确保 Maven下 conf/settigs.xml 或者用户的 settings.xml 是否有正确配置镜像地址和远程仓库地址

12. 项目文件路劲和安装包路径有什么区别？    
项目文件路径是 Git 下载下来后项目文件存放的地址；安装包路径是使用 Maven 编译后将安装包解压后存放的地址；数据库初始化脚本存于项目文件路径下；其他的参数配置文件都在安装包路径下

13. 为什么使用 Executor 启动脚本启动 Executor 时，先是提示启动成功，后面又一直出现更新数据库失败的提示？    
请耐心等待，直到确认已经全部失败后，再查看日志确认具体报错原因。

14. java.lang.NoClassDefFoundError: Could not initialize class org.forgerock.opendj.ldap.LDAPConnectionFactory

    这个是因为web打包的时候少了opendj两个相关的包，需要把azkaban-common/extlib下opendj-core-3.0.0.jar和opendj-grizzly-3.0.0.jar添加到schedulis_0.5.0_web/lib里面

15. azkaban.executor.ExecutorManagerException: No active executors found

    修改数据库schedulis下executors表active字段0修改为1（官网方法：curl http://localhost:8081/executor?action=activate），在重新启动web项目

16. 所有配置文件找不到的

    都使用绝对路径配置

17. azkaban.utils.StdOutErrRedirect - Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'.

    修改源码azkaban-db下 MySQLDataSource setDriverClassName("com.mysql.cj.jdbc.Driver")和azkaban-common 下MySQLBasicDataSource setDriverClassName("com.mysql.cj.jdbc.Driver");

18. 为什么在启动 Executor 的时候，先是提示启动成功，后面就一直卡在更新数据库失败的提示很久，失败次数也没有更新？    
    对于这种情况，很大原因是数据库连接时出现了问题，请停止启动进程，并查看日志确认错误原因。按需查看 QA 章节。

# 二、idea运行Schedulis 源码

### 一）、azkaban-exec-server环境准备 

1. 启动配置文件环境变量添加azkaban-exec-server\src\绝对路径，让程序可以读取到conf/azkaban.properties配置文件

   AZKABAN_HOME=G:\workspace\Schedulis\azkaban-exec-server\src\

2. conf/azkaban.properties配置文件程序读取找不到那个目录，就把配置文件里面参数修改为绝对路径

3. azkaban.properties配置文件主要配置

   ```yaml
   # Loader for projects 修改为绝对路径
   executor.global.properties=G:/workspace/ljsjzt2.0/Schedulis/azkaban-exec-server/src/conf/global.properties
   azkaban.project.dir=projects
   
   database.type=mysql         #数据库类型(目前只支持mysql)
   mysql.port=3306             #数据库端口号
   mysql.host=localhost        #数据库IP地址
   mysql.database=schedulis    #数据库实例名
   mysql.user=root             #数据库用户名
   mysql.password=MTIzNDU2     #数据库密码
   mysql.numconnections=100    #最大连接数
   
   executor.server.id=2 #注册executors时使用ID，记录的是 Executor 端的所有执行节点 Hostname 和 ServerId
   executor.port=12321  #端口号(如修改,请与web服务中一致)
   # Web Server curl http://localhost:8081/executor?action=activate
   azkaban.webserver.url=http://localhost:8081
   ```

### 二）、azkaban-web-server环境准备 

1. 启动配置文件环境变量添加azkaban-web-server\src\绝对路径，让程序可以读取到conf/azkaban.properties配置文件

   AZKABAN_HOME=G:\workspace\Schedulis\azkaban-web-server\src\

2. ldap的jar包引入

   复制azkaban-common/extlib下opendj-core-3.0.0.jar、opendj-grizzly-3.0.0.jar到azkaban-web-server/extlib

   azkaban-web-server的pom.xml文件加入

   ```xml
   <dependency>
      <groupId>org.opendj.commons</groupId>
      <artifactId>opendj-core</artifactId>
      <version>-3.0.0</version>
      <scope>system</scope>
      <systemPath>${project.basedir}/extlib/opendj-core-3.0.0.jar</systemPath>
   </dependency>
   <dependency>
      <groupId>org.opendj.commons</groupId>
      <artifactId>opendj-grizzly</artifactId>
      <version>3.0.0</version>
      <scope>system</scope>
      <systemPath>${project.basedir}/extlib/opendj-grizzly-3.0.0.jar</systemPath>
   </dependency>
   ```

3. conf/azkaban.properties配置文件主要配置

   ```yml
   # Azkaban Personalization Settings
   azkaban.name=WeDataSphere #服务器UI名称,用于服务器上方显示的名字
   azkaban.label=WeBank  #描述
   azkaban.color=#FF3601  #UI颜色
   azkaban.default.servlet.path=/index
   web.resource.dir=G:/workspace/ljsjzt2.0/Schedulis/azkaban-web-server/src/web  #默认根web目录
   default.timezone.id=Asia/Shanghai  #默认时区,已改为亚洲/上海 默认为美国
   
   # Azkaban UserManager class
   #user.manager.class=WebankXmlUserManager
   user.manager.class=com.webank.wedatasphere.schedulis.common.user.SystemUserManager  #用户权限管理默认类
   user.manager.xml.file=conf/azkaban-users.xml #用户配置,具体配置参加下文
   #cd /azkaban-web-2.5.0/conf/
   #vi azkaban-users.xml
   #增加管理员用户
   #<azkaban-users>
   #    <user username="azkaban" password="azkaban" roles="admin" groups="azkaban" />
   #    <user username="metrics" password="metrics" roles="metrics"/>
   #    <user username="admin" password="admin" roles="admin,metrics" />
   #    <role name="admin" permissions="ADMIN" />
   #    <role name="metrics" permissions="METRICS"/>
   #</azkaban-users>
   
   # Loader for projects
   executor.global.properties=conf/global.properties # global配置文件所在位置
   azkaban.project.dir=projects
   
   database.type=mysql         #数据库类型(目前只支持mysql)
   mysql.port=3306             #数据库端口号
   mysql.host=localhost        #数据库IP地址
   mysql.database=schedulis    #数据库实例名
   mysql.user=root             #数据库用户名
   mysql.password=MTIzNDU2     #数据库密码
   mysql.numconnections=100    #最大连接数
   
   # Velocity dev mode
   velocity.dev.mode=false
   
   # Azkaban Jetty server properties.
   jetty.use.ssl=false
   jetty.maxThreads=25  #最大线程数
   jetty.ssl.port=8443  #Jetty SSL端口
   jetty.port=8081   #Jetty端口
   jetty.send.server.version=false
   jetty.keystore=keystore/azkabanjetty.keystore  #SSL文件名
   jetty.password=hadoop  #SSL文件密码
   jetty.keypassword=hadoop  #Jetty主密码 与 keystore文件相同
   jetty.truststore=keystore/azkabanjetty.keystore #SSL文件名
   jetty.trustpassword=hadoop # SSL文件密码
   #jetty.hostname=[#jetty_host]
   # Azkaban Executor settings
   executor.port=12321   #执行服务器端口
   
   # mail settings
   mail.sender=azkaban   #发送邮箱
   mail.host=[#Mail_host]  #发送邮箱smtp地址
   #mail.user=azkaban@ptbird.cn
   #mail.password=hadoop
   #job.failure.email=   #任务失败时发送邮件的地址
   #job.success.email=   #任务成功时发送邮件的地址
   
   cache.directory=cache  #缓存目录
   
   # LDAP Connection settings
   ladp.ip=172.18.42.176
   ladp.port=9001
   
   ```

   