
port=$1
config_str=$2

if [ ! -f /etc/mongod.d/mongos-${port}.conf ];then
	sed "s/PORT/${port}/g" /etc/mongod.d/mongos.conf.template >> /etc/mongod.d/mongos-${port}.conf
	sed -ie "s/CONFIGSTR/${config_str}/g" /etc/mongod.d/mongos-${port}.conf
fi
systemctl enable mongos@${port}
systemctl start mongos@${port}
sleep 5
systemctl status mongos@${port}