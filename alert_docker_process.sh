#!/bin/bash
#anthor ： guonh
#date：2021-10-18
#describe：查询进程是否存在，若存在则输出0到文件，telegraf查询文件内容储存到prometheus

ISEXIST=`ps -ef|grep  "gamex"|grep 4004 > /dev/null;echo $?`
if [ ${ISEXIST} == "0" ];then
 echo "0" > /tmp/Alive_gamex_4004
else
 echo "1" > /tmp/Alive_gamex_4004
fi

ISEXIST=`ps -ef|grep  "gamex"|grep 4005 > /dev/null;echo $?`
if [ ${ISEXIST} == "0" ];then
 echo "0" > /tmp/Alive_gamex_4005
else
 echo "1" > /tmp/Alive_gamex_4005
fi

#notice2
ISEXIST=`ps -ef|grep "/work/code/notice"|grep -v "grep">/dev/null;echo $?`
if [ ${ISEXIST} == "0" ];then
 echo "0" > /tmp/Alive_notice2
else
 echo "1" > /tmp/Alive_notice2
fi

#room2
ISEXIST=`ps -ef|grep "/work/code/room"|grep -v "grep">/dev/null;echo $?`
if [ ${ISEXIST} == "0" ];then
 echo "0" > /tmp/Alive_room2
else
 echo "1" > /tmp/Alive_room2
fi
