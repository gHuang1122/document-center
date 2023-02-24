## 一、数据库安装

1、新建docker-compose.yml文件

```yml
version: '3'
services:
  postgres:
    image: kartoza/postgis:11.0-2.5
    container_name: postgres_dc
    volumes:
      - ./pgdata:/var/lib/postgresql
    environment:
      POSTGRES_USER: postgres #在此填写postgres的用户名
      POSTGRES_DB: postgres #在此填写postgres的数据库名，默认是postgres
      POSTGRES_PASSWORD: windows-999 #在此填写posgres的数据库密码
    ports:
      - "5432:5432"
    logging:
      options:
        max-size: 10mb
  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin_dc
    environment:
      PGADMIN_DEFAULT_EMAIL: Mr-jgl@outlook.com #在此填写pgAdmin登录账户邮箱
      PGADMIN_DEFAULT_PASSWORD: windows-999 #在此填写pgAdmin密码
    ports:
      - "5050:80"
    logging:
      options:
        max-size: 10mb
```

2、启动命令

docker-compose up

3、关闭命令

docker-compose down

4、网页输入http://localhost:5050/browser/

5、项目resource下db文件，初始化数据库表。

## 二、项目技术

> ##### 基于PostgreSQL和PostGIS的坐标转换函数，支持点、线、面的WGS84和CGCS2000与GCJ02和BD09坐标系与之间互转。

## Example

```sql
-- 如果转换后结果为null，查看geom的srid是否为4326或者4490
WGS84转GCJ02
select geoc_wgs84togcj02(geom) from test_table
GCJ02转WGS84
select geoc_gcj02towgs84(geom) from test_table

WGS84转BD09
select geoc_wgs84tobd09(geom) from test_table
BD09转WGS84
select geoc_bd09towgs84(geom) from test_table

CGCS2000转GCJ02
select geoc_cgcs2000togcj02(geom) from test_table
GCJ02转CGCS2000
select geoc_gcj02tocgcs2000(geom) from test_table

CGCS2000转BD09
select geoc_cgcs2000tobd09(geom) from test_table
BD09转CGCS2000
select geoc_bd09tocgcs2000(geom) from test_table

GCJ02转BD09
select geoc_gcj02tobd09(geom) from test_table
BD09转GCJ02
select geoc_bd09togcj02(geom) from test_table
```

## 使用

```
PostgreSQL安装PostGIS扩展
复制geoc-pg-coordtansform.sql中代码，在数据库执行
```
