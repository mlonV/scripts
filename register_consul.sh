#!/bin/bash
#by guonh
#2021-08-24
#监控组件telegraf注册到consul，prometheus自动发现监控主机

#telegraf 服务的ip/port
#取eth0
ip=`ip a show eth0|grep "inet"|awk '{print $2}'|awk -F'/' '{print $1}'`
port=9273
#项目名
project="paipai"
hostname=`hostname`
#consul 地址
consul_addr="http://172.19.64.29:8500"



#注册到监控机的consul
#/usr/local/bin/consul services register -id=${hostname} -name=${project} -address=${ip} -port=${port} -tag=${project} -http-addr=${consul_addr}
#设置 服务宕机超过时常自动取消注册
curl --request PUT --data '{"ID": "'${hostname}'","Name": "'${project}'",  "Address": "'${ip}'","Port":'${port}',"Tags":["'${project}'"],"Check":{"HTTP":"http://'${ip}':'${port}'/metrics","Interval": "6s","DeregisterCriticalServiceAfter":"24h"}}' ${consul_addr}/v1/agent/service/register?replace-existing-checks=1
