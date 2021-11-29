#!/bin/bash
# anthor: guonh
# date: 2021-11-29
# describe: 让telegraf执行该脚本监控程序pid变化


dockerName="$1"
#ps的时候查绝对路径，文件命名字的时候用basename
processName="$2"
processFileName=`basename $2`
#第一位状态0正常/1异常（进程号被修改），第二位当进程号异常开始0-5计数，超过5次还原1状态到0. 小数点后为pid  第四位给telegraf收集告警用(前三位的整合为一个数据)

#例如：    告警策略 指标大于1的话告警正常为小数 0.pid
#文件内容: 0 0 pid 0.pid        (0正常状态xxxx进程号)
#文件内容: 1 2 pid 12.pid       (状态为1  轮训到第2次  进程号为xxxx )
pidStatusFileName=/tmp/${dockerName}_${processFileName}.status

#多少次重置状态
num=100

#获取当前进程pid
PID=`docker exec -i ${dockerName} bash -c "ps -ef|grep -v grep |grep -v '${0}'|grep ${processName}|awk '{print \\$2}'"`
if [ ! -f ${pidStatusFileName} ];then
    #第一次执行
    #如果status文件不存在则直接输入正常状态  pid也直接写入文件
    echo "0 0 ${PID} 0.${PID}" > ${pidStatusFileName}
else
    #当前文件内状态
    FileStatus=`cat ${pidStatusFileName}|awk '{print $1}'`
    #当前文件内计数
    FileNum=`cat ${pidStatusFileName}|awk '{print $2}'`
    #当前文件内pid
    FilePID=`cat ${pidStatusFileName}|awk '{print $3}'`

    #如果文件内记录PID和当前ps得到的pid不一样
    if [ ${PID} -ne ${FilePID} ];then
        #超过 num 次就不搞了，还原状态
        if [ ${FileNum} -gt ${num} ];then
            #还原状态,且写入最新的pid到文件
            FileNum=0
            echo "0 ${FileNum} ${PID} 0.${PID}" > ${pidStatusFileName}
        else
            #修改状态
            FileNum=$((FileNum+1))
            echo "1 ${FileNum} ${FilePID} 1${FileNum}.${FilePID}" > ${pidStatusFileName}
            #虽然修改了状态，但是pid不去更新。等超过num次了重置状态在更新
        fi
    fi
fi
