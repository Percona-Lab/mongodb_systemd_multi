#!/bin/bash

# Get Mongo Latest or Specfic Version
# Creat User/Group
# Create DataPath
# Create Log Folers
# Create Config Folders
# Copy mongos, mongod, and config templates into place
# Create inital mongod-27017.conf config
# Copy Service into place
# Create inital mongod@27017 service
# Print out example steps to build mongod@27018

##########################################
####### Functions ########################
##########################################

function usage() {
  cat << EOF
  usage: $0 --get-binaries --inital-mongod --guide --add-user --setup-paths

  this script uses arguments from command line and runs echos arguments

  OPTIONS:
     -h
     -g | --no-get-binaries <boolean> [true] , 	Gets latest mongod binaries and installs them to /usr/bin/
     -i | --no-initial-mongod <boolean> [true], 	Setup default Mongod on 27017
     -G | --no-guide <boolean> [true], 			Print out example of setup steps for next mongod process
     -a | --no-add-user <boolean> [true],			Added mongod user and group to system for use with setup-paths
     -s | --no-setup-paths <boolean> [true],		Setup default config, log, and data paths 
  
EOF  
}
function clone(){
	mkdir /opt/percona-lab/mongodb-multi
	if [ -d /etc/mongod ];then
		mv /etc/mongod /etc/mongod.d
	else
		mkdir -p /etc/mongod.d
	fi

	cp -r `dirname $0`/* /opt/percona-lab/mongodb-multi/.
	cp /opt/percona-lab/mongodb-multi/conf/*  /etc/mongod.d/.
}
function download_bins(){
	echo cd ${1}
	echo wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${2}.tgz
	echo tar zxvf *${2}*.tgz
	echo cp mongo*${2}*/bin/* /usr/local/bin/. 
}
function inital_config(){
	/opt/percona-lab/mongodb-multi/helpers/add_mongod.sh 27017 rs1

function print_guide(){
	cat /opt/percona-lab/mongodb-multi/GUIDE
}
function add_user_and_group(){
	/opt/percona-lab/mongodb-multi/helpers/add_user_and_group.sh
}
function setup_dirs(){
		mkdir -p /var/log/mongod.d
		mkdir -p /data
		chown -R mongod:mongod /etc/mongod.d /data /var/log/mongod.d 
}



###########################################
####### Main Body #########################
###########################################
TEMP=`getopt -o hgiGasV --long binary-version,no-get-binaries,no-initial-mongod,no-guide,no-add-user,no-setup-paths -n 'install.sh' -- "$@"`
if [ $? != 0 ] ; then 
	echo "Parse Failure, Terminating..." >&2 ; 
	exit 1 ; 
fi

eval set -- "$TEMP"

BINARIES=true
INITIAL=true
GUIDE=true
ADD_USER=true
SETUP_PATHS=true

while true; do
  case "$1" in
  	-h ) 						usage(); exit 1;;
    -g | --get-binaries)		BINARIES=false;shift 1 ;;
    -V | --binary-version)		BIN_VER=$2; shift 2 ;;
    -i | --initial-mongod)		INITIAL=false;shift 1 ;;
    -G | --guide)				GUIDE=false;shift 1 ;;
	-a | --add-user)			ADD_USER=false;shift 1 ;;
	-s | --setup-paths)			SETUP_PATHS=false;shift 1 ;;
    * ) break ;;
  esac
done


echo Binaries 		$BINARIES
echo Initial 		$INITIAL
echo Guide 			$GUIDE
echo Add_User 		$ADD_USER
echo Setup paths 	$SETUP_PATHS

if [ $ADD_USER ];then
	add_user_and_group
fi
if [ $SETUP_PATHS ];then	
	setup_dirs
fi
if [ $BINARIES ];then
	download_bins "/tmp/" $BIN_VER
fi
if [ $INITIAL ];then
	inital_config 
fi
if [ $GUIDE ];then
	print_guide 
fi


