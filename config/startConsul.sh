#consul 启动命令
cd /usr/local/consul ;nohup consul agent -server -data-dir=/usr/local/consul -bootstrap-expect=1 -bind=172.19.64.29 -client=172.19.64.29 -ui &



#README
#在agent节点上注册服务，prometheus来获取节点
# 注册服务
#consul services register -id=node-1 -name=node-1 -address=172.19.64.29 -port=9273 -tag=telegraf

# 注销服务
#consul services deregister -id node-1


#有个bug 同时开启伸缩组的机器会出现一个service为work-app221110000的机器，会导致注册的伸缩组机器不全，手动注销命令
# consul services deregister -id work-app221110000 -http-addr http://172.19.64.29:8500