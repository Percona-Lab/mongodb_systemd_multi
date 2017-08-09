
port=$1

if [ ! -f /etc/mongod.d/config-${port}.conf ];then
	sed "s/PORT/${port}/g" /etc/mongod.d/config.conf.template >> /etc/mongod.d/config-${port}.conf
fi
systemctl enable mongo_config@${port}
systemctl start mongo_config@${port}
sleep 5
systemctl status mongo_config@${port}