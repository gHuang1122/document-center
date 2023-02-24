# 数据中台部署文档--docker单机部署hadoop和hive

## 前提条件：
centos7.6已安装好docker及docker-compose，参考数据中台部署文档-基础环境

## 编写docker-compose.yaml文件

```
version: "3"

services:
  namenode:
    image: harbor.software.dc/mpdata/hadoop-namenode:2.0.0-hadoop2.7.4-java8
    volumes:
      - namenode:/hadoop/dfs/name
    environment:
      - CLUSTER_NAME=test
    env_file:
      - ./hadoop-hive.env
    ports:
      - "50070:50070"
      - "8020:8020"
  datanode:
    image: harbor.software.dc/mpdata/hadoop-datanode:2.0.0-hadoop2.7.4-java8
    volumes:
      - datanode:/hadoop/dfs/data
    env_file:
      - ./hadoop-hive.env
    environment:
      SERVICE_PRECONDITION: "namenode:50070"
    ports:
      - "50010:50010"
      - "50020:50020"
      - "50075:50075"
  resourcemanager:
    image: harbor.software.dc/mpdata/hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8
    container_name: resourcemanager
    environment:
      SERVICE_PRECONDITION: "namenode:50070 datanode:50075"
    env_file:
      - ./hadoop-hive.env
    ports:
      - "8030:8030"
      - "8031:8031"
      - "8032:8032"
      - "8088:8088"

  nodemanager1:
    image: harbor.software.dc/mpdata/hadoop-nodemanager:2.0.0-hadoop2.7.4-java8
    container_name: nodemanager
    environment:
      SERVICE_PRECONDITION: "namenode:50070 datanode:50075 resourcemanager:8088"
    env_file:
      - ./hadoop-hive.env
    ports:
      - "8042:8042"
  
  historyserver:
    image: harbor.software.dc/mpdata/hadoop-historyserver:2.0.0-hadoop2.7.4-java8
    container_name: historyserver
    environment:
      SERVICE_PRECONDITION: "namenode:50070 datanode:50075 resourcemanager:8088"
    volumes:
      - hadoop_historyserver:/hadoop/yarn/timeline
    env_file:
      - ./hadoop-hive.env
    ports:
      - "8188:8188"
      - "10020:10020"

  hive-server:
    image: harbor.software.dc/mpdata/hive:1.2.1-postgresql-metastore
    env_file:
      - ./hadoop-hive.env
    environment:
      HIVE_CORE_CONF_javax_jdo_option_ConnectionURL: "jdbc:postgresql://hive-metastore/metastore"
      SERVICE_PRECONDITION: "hive-metastore:9083"
    ports:
      - "10000:10000"
  hive-metastore:
    image: harbor.software.dc/mpdata/hive:1.2.1-postgresql-metastore
    env_file:
      - ./hadoop-hive.env
    command: /opt/hive/bin/hive --service metastore
    environment:
      SERVICE_PRECONDITION: "namenode:50070 datanode:50075 hive-metastore-postgresql:5432"
    ports:
      - "9083:9083"
  hive-metastore-postgresql:
    image: harbor.software.dc/mpdata/hive-metastore-postgresql:1.2.0
    ports:
      - "5432:5432"
  presto-coordinator:
    image: harbor.software.dc/mpdata/prestodb:0.183
    ports:
      - "8080:8080"

volumes:
  namenode:
  datanode:
  hadoop_historyserver:

networks:
  default:
    external:
      name: hadoop-ljzt

```

## 编写hadoop-hive.env配置文件
```
HIVE_SITE_CONF_javax_jdo_option_ConnectionURL=jdbc:postgresql://hive-metastore-postgresql/metastore
HIVE_SITE_CONF_javax_jdo_option_ConnectionDriverName=org.postgresql.Driver
HIVE_SITE_CONF_javax_jdo_option_ConnectionUserName=hive
HIVE_SITE_CONF_javax_jdo_option_ConnectionPassword=hive
HIVE_SITE_CONF_datanucleus_autoCreateSchema=false
HIVE_SITE_CONF_hive_metastore_uris=thrift://hive-metastore:9083
HDFS_CONF_dfs_namenode_datanode_registration_ip___hostname___check=false

CORE_CONF_fs_defaultFS=hdfs://namenode:8020
CORE_CONF_hadoop_http_staticuser_user=root
CORE_CONF_hadoop_proxyuser_hue_hosts=*
CORE_CONF_hadoop_proxyuser_hue_groups=*

HDFS_CONF_dfs_webhdfs_enabled=true
HDFS_CONF_dfs_permissions_enabled=false

YARN_CONF_yarn_log___aggregation___enable=true
YARN_CONF_yarn_resourcemanager_recovery_enabled=true
YARN_CONF_yarn_resourcemanager_store_class=org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore
YARN_CONF_yarn_resourcemanager_scheduler_class=org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler
YARN_CONF_yarn_scheduler_capacity_root_default_maximum___allocation___mb=8192
YARN_CONF_yarn_scheduler_capacity_root_default_maximum___allocation___vcores=4
YARN_CONF_yarn_resourcemanager_fs_state___store_uri=/rmstate
YARN_CONF_yarn_nodemanager_remote___app___log___dir=/app-logs
YARN_CONF_yarn_log_server_url=http://historyserver:8188/applicationhistory/logs/
YARN_CONF_yarn_timeline___service_enabled=true
YARN_CONF_yarn_timeline___service_generic___application___history_enabled=true
YARN_CONF_yarn_resourcemanager_system___metrics___publisher_enabled=true
YARN_CONF_yarn_resourcemanager_hostname=resourcemanager
YARN_CONF_yarn_timeline___service_hostname=historyserver
YARN_CONF_yarn_resourcemanager_address=resourcemanager:8032
YARN_CONF_yarn_resourcemanager_scheduler_address=resourcemanager:8030
YARN_CONF_yarn_resourcemanager_resource__tracker_address=resourcemanager:8031
YARN_CONF_yarn_timeline___service_enabled=true
YARN_CONF_yarn_timeline___service_generic___application___history_enabled=true
YARN_CONF_yarn_timeline___service_hostname=historyserver
YARN_CONF_mapreduce_map_output_compress=true
YARN_CONF_mapred_map_output_compress_codec=org.apache.hadoop.io.compress.SnappyCodec
YARN_CONF_yarn_nodemanager_resource_memory___mb=16384
YARN_CONF_yarn_nodemanager_resource_cpu___vcores=8
YARN_CONF_yarn_nodemanager_disk___health___checker_max___disk___utilization___per___disk___percentage=98.5
YARN_CONF_yarn_nodemanager_remote___app___log___dir=/app-logs
YARN_CONF_yarn_nodemanager_aux___services=mapreduce_shuffle

MAPRED_CONF_mapreduce_framework_name=yarn
MAPRED_CONF_mapred_child_java_opts=-Xmx4096m
MAPRED_CONF_mapreduce_map_memory_mb=4096
MAPRED_CONF_mapreduce_reduce_memory_mb=8192
MAPRED_CONF_mapreduce_map_java_opts=-Xmx3072m
MAPRED_CONF_mapreduce_reduce_java_opts=-Xmx6144m

```

## 启动镜像
```
#需要先创建网络
docker network create hadoop-ljzt
#启动
docker-compose up -d
#查看已启动的容器
docker-compose ps -a
#重启
docker-compose restart
```


## 测试

```
进入hive命令行
docker-compose exec hive-server /bin/bash
hive
show databases;
use ljgk_dw;
show tables;
#建表语句
create table ljgk_dw.d_area(id int, name string) row format delimited fields terminated by "\t";
#导入数据
load data local inpath '/opt/load_d_area.txt' into table ljgk_dw.d_area;
#查看表
show tables;
#查询数据
select * from ljgk_dw.d_area;
#删除表重建
drop table if exists ljgk_dw.d_area;


```

## 镜像制作方法(文档待完成)
```
hadoop相关镜像制作脚本在http://gitlab.software.dc/mp-data/dss/docker-hadoop/-/tree/2.0.0-hadoop2.7.4-java8

hive相关镜像制作脚本在http://gitlab.software.dc/mp-data/dss/docker-hive
```

## hadoop-namenode:2.0.0-hadoop2.7.4-java8


## hadoop-datanode:2.0.0-hadoop2.7.4-java8


## hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8


## hadoop-nodemanager:2.0.0-hadoop2.7.4-java8


## hadoop-historyserver:2.0.0-hadoop2.7.4-java8


## hive-server/hive-metastore


## hive-metastore-postgresql:1.2.0


## presto-coordinator


## hue(待添加)


