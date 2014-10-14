#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "STEP1"
echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
echo "STEP2"
cd ~
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc

apt-get update

echo "STEP3"
apt-get install erlang --assume-yes
echo "STEP4"
apt-get install rabbitmq-server --assume-yes


echo "STEP5"
rabbitmqctl add_user admin admin
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
rabbitmqctl delete_user guest

echo "STEP6"
rabbitmq-plugins enable rabbitmq_management

echo "STEP7"
service rabbitmq-server restart

#rabbitmqctl stop
#rabbitmqctl start