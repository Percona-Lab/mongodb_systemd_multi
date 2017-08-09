
port=$1
replset=$2

if [ ! -f /etc/mongod.d/mongod-${port}.conf ];then
	sed "s/PORT/${port}/g" /etc/mongod.d/mongod.conf.template >> /etc/mongod.d/mongod-${port}.conf
	sed -ie "s/#replset=REPLSET/replset=${config_str}/g" /etc/mongod.d/mongod-${port}.conf
fi
systemctl enable mongod@${port}
systemctl start mongod@${port}
sleep 5
systemctl status mongod@${port}