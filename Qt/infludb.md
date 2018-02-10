# Qt

----------

InfluxDB操作记录
----------------
在不设置用户名和密码的情况下通过终端打开 **influxDB**

>zypc@zypc-MS-7851:~$ influx
>Visit https://enterprise.influxdata.com to register for updates, InfluxDB server management, and monitoring.
>Connected to http://localhost:8086 version 0.13.0
>InfluxDB shell version: 0.13.0
----------

使用帮助，不能直接使用**'?'**

> help
> Usage:
>        connect <host:port>   connects to another node specified by host:port
>        auth                  prompts for username and password
>        pretty                toggles pretty print for the json format
>        use <db_name>         sets current database
>        format <format>       specifies the format of the server responses: json, csv, or column
>        precision <format>    specifies the format of the timestamp: rfc3339, h, m, s, ms, u or ns
>        consistency <level>   sets write consistency level: any, one, quorum, or all
>        history               displays command history
>        settings              outputs the current settings for thegit  shell
>        exit/quit/ctrl+d      quits the influx shell
>
>        show databases        show database names
>        show series           show series information
>        show measurements     show measurement information
>        show tag keys         show tag key information
>        show field keys       show field key information
>
>        A full list of influxql commands can be found at:
>        https://docs.influxdata.com/influxdb/latest/query_language/spec/
>
> 
----------

创建数据库
```
 > CREATE DATABASE nimbot
 > use nimbot
 Using database nimbot
```
----------

删除数据库
```
 DROP DATABASE "database name"
```
----------

显示所有的数据库
```
> show databases
 name: databases

 name
 _internal
 zydb
```
----------

使用数据库
```
>use zydb
Using database zydb
```
----------



