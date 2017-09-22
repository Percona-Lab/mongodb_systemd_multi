#!/bin/bash
#
PATH="${PATH}:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
CONF="/etc/mongod.d/${1}.conf"
ENVFILE="/etc/mongod.d/${1}.env"

#Create ENVFILE if missing
if [ ! -f ${ENVFILE} ];then
	touch  ${ENVFILE}
fi


#Check for CPU Affinity in mongo config file
CPUS_ALLOWED=""
CPU_INCONF=$(egrep -c '^#CPUS_ALLOWED' ${CONF})
CPU_INENV=$(grep -c 'CPUS_ALLOWED' ${ENVFILE})
if [ $CPU_INCONF = 1 && $CPU_INENV = 0 ];then
		CPUS_ALLOWED=$(egrep '^#CPUS_ALLOWED' ${CONF} | cut -d "=" -f2)
		echo "CPUS_ALLOWED=${CPUS_ALLOWED}" >> ${ENVFILE}
fi
