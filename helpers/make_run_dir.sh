#!/bin/bash

/usr/bin/mkdir -p /var/run/mongodb
/usr/bin/chown mongod:mongod /var/run/mongodb
/usr/bin/chmod 0755 /var/run/mongodb