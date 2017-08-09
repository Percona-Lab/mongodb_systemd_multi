#!/bin/bash
#
id mongod &>/dev/null
if [ "$?" -eq 1 ];
	useradd mongod
fi