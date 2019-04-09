# mysql主从
### 主数据库
* 创建 MYSQL master 容器
docker run --name mysql-master -itd -p 3306:3306 -v /www/data:/data ucse/mysql

* 查看 master 状态
docker exec -it mysql-master bash

* 创建主从用户backup 密码mysql_master
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
GRANT REPLICATION SLAVE ON *.* to 'backup'@'%' identified by 'mysql_master';

* 备份主数据库数据(可以不操作)
mysqldump -u root -h 127.0.0.1 -p –flush-logs –master-data=2 –single-transaction –routines –triggers –events –all-databases > /data/slave.sql

### 从数据库
* 创建 MYSQL slave 容器
docker run --name mysql-slave -itd -p 3316:3306 ucse/mysql:slave

### 建立关系
* 主数据库容器，查询出的 Position和ip(ip灵活运用，只要能连到主库就ok)
mysql> show master status;

* 从数据库，设置相关参数
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
change master to master_host='172.16.3.174',master_user='backup',master_password='mysql_master',master_log_file='logs.000005',master_log_pos=3311;

* 启动slave服务
mysql> start slave;
* 查看服务状态
mysql> show slave status;
显示
Waiting for master to send event
说明主从成功了。