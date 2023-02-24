# metricbeat监控系统服务

目录: /app/elk

docker-compose .yml文件，改文件本机启动一个单机版的elasticsearch,kibana

```
version: '3.1'
services:

  kibana:
    image: docker.elastic.co/kibana/kibana:7.3.0
    environment:
      ELASTICSEARCH_HOSTS: "http://172.18.8.167:9200"
    volumes:
      - ./search/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml
    ports:
      - "5601:5601"
    container_name: kibana
    restart: always

  logstash:
    image: docker.elastic.co/logstash/logstash:7.3.0
    command: logstash -f /etc/logstash/config/logstash.conf --config.reload.automatic #logstash 启动时使用的配置文件
    volumes:
      - ./search/logstash/config/logstash.conf:/etc/logstash/config/logstash.conf  #logstash 配文件位置
      - /app/elk/logs:/app/elk/logs
      - ./search/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml  #logstash 配文件位置
    ports:
      - "4560:4560"
      - "9600:9600"
    container_name: logstash

  ys-mysql:
    image: mysql:5.7
    container_name: ys-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 123456
      TZ: Asia/Shanghai
    volumes:
      - ./data/mysql/logs:/var/log/mysql/
      - /data/mysql/mydata:/var/lib/mysql
      - /data/mysql/conf.d/my.cnf:/etc/mysql/conf.d/my.cnf
    ports:
      - "23306:3306"
 

  collect-file:
    image: 'openjdk:8-alpine'
    restart: always
    ports:
      - "28099:8099"
    container_name: 'collect-file' 
    volumes:
      - ./collectToFile-1.0.0.jar:/app/collectToFile-1.0.0.jar
      - /app/elk/logs:/app/elk/logs
      - ./search/logstash/config/logstash.conf:/app/elk/search/logstash/config/logstash.conf
    command: ['java', '-jar', '/app/collectToFile-1.0.0.jar','--spring.profiles.active=dev']

  es01:
    image: yaoguoh/elasticsearch-ik-pinyin:7.3.0
    container_name: es01
    restart: always
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"
      - "9300:9300"
```

对于如何启动 metricbeat

1、下载metricbeat相关版本的镜像

```
docker pull docker.elastic.co/beats/metricbeat:7.3.0
```

2、下载配置文件

```
curl -L -O https://raw.githubusercontent.com/elastic/beats/7.3.0/deploy/docker/metricbeat.docker.yml
```

这时， /app/elk目录下会多一个metricbeat.docker.yml配置文件

配置文件配置详情

```
metricbeat.config:
  modules:
    path: ${path.config}/modules.d/*.yml
    # Reload module configs as they change:
    reload.enabled: false

metricbeat.autodiscover:
  providers:
    - type: docker
      hints.enabled: true

metricbeat.modules:
- module: docker
  metricsets:
    - "container"
    - "cpu"
    - "diskio"
    - "healthcheck"
    - "info"
    #- "image"
    - "memory"
    - "network"
  hosts: ["unix:///var/run/docker.sock"]
  period: 10s
  enabled: true

processors:
  - add_cloud_metadata: ~

output.elasticsearch:
  hosts: ["http://172.18.8.167:9200"]   //配置elasticsearch

# 加载默认模板
setup.dashboards.enabled: true
 
# 设置如果存在模板，则不覆盖原有模板
setup.template.overwrite: false
 
# 设置kibana服务地址，不设置的话可能在加载Dashboard时会报错
setup.kibana:
  host: "http://172.18.8.167:5601"   //配置展示的kibana地址

```

3、启动容器

```
docker run -d \
  --name=mb \
  --user=root \
  --volume="$(pwd)/metricbeat.docker.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
  --volume="/proc:/hostfs/proc:ro" \
  --volume="/:/hostfs:ro" \
  docker.elastic.co/beats/metricbeat:7.3.0
```

4、启动之后

```
ljgk@poseidon-nvdia:~$ docker ps
CONTAINER ID        IMAGE                                                         COMMAND                  CREATED             STATUS              PORTS                                                      NAMES
21d86751c1cf        docker.elastic.co/beats/metricbeat:7.3.0                      "/usr/local/bin/dock…"   9 days ago          Up 9 days                                                                      mb
```

5、默认开启监控cpu、内存、硬盘等资源

