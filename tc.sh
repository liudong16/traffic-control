tc qdisc del dev enp0s25 root 
# 添加根队列
tc qdisc add dev enp0s25 root handle 1: cbq bandwidth 10Mbit avpkt 1000 cell 8 mpu 64

# 添加根分类
tc class add dev enp0s25 parent 1:0 classid 1:1 cbq bandwidth 10Mbit rate 10Mbit maxburst 20 allot 1514 prio 1 avpkt 1000 cell 8 weight 1Mbit
# 添加子分类
tc class add dev enp0s25 parent 1:1 classid 1:2 cbq bandwidth 10Mbit rate 64Kbit maxburst 20 allot 1514 prio 2 avpkt 1000 cell 8 weight 1Mbit
tc class add dev enp0s25 parent 1:1 classid 1:3 cbq bandwidth 10Mbit rate 64Kbit maxburst 20 allot 1514 prio 3 avpkt 1000 cell 8 weight 100Kbit bounded

# 设置队列规则
tc qdisc add dev enp0s25 parent 1:2 sfq quantum 1514b perturb 15
tc qdisc add dev enp0s25 parent 1:3 sfq quantum 1514b perturb 15

# 将iptables的标记和过滤器映射起来
tc filter add dev enp0s25 parent 1:0 protocol ip prio 1 handle 2 fw classid 1:2
tc filter add dev enp0s25 parent 1:0 protocol ip prio 1 handle 3 fw classid 1:3
