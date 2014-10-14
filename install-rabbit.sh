#!/usr/bin/env bash
# pmcgrath @ 15/11/2013
#
# See http://www.rabbitmq.com/install-debian.html
# 	Will install latest version
# 	Will rely on RabbitMQ to install Erlang
# 	Will configure as a daemon
#
# ccsadmin and ccsmonitor passwords are stored in \\trafs01a.ccs.local\shared\passwordsafe\continuum.psafe3
#
# Pre-conditions
if [ "$(whoami)" != "root" ]; then
	echo "You must run this script as root !"
	exit 1
fi
if [ $# -ne 7 ]; then
	echo "Need 7 parameters !"
	echo "Usage is (note initial space)"
	echo " $0 proxy_ip_and_port comma_separated_data_client_addresses comma_separated_management_client_addresses adminusername adminuserpassword monitorusername monitoruserpassword"
	echo " $0 'n\a' 172.17.0.0/24 172.17.0.0/24,172.18.0.0/24 ccsadmin asecretpassword ccsmonitor anothersecretpassword"
	echo " $0 'n\a' 172.17.0.0/24 172.17.0.0/24,172.18.0.0/24 ccsadmin 'as % !98345 d' ccsmonitor 'ted was % !98345'"
	echo " $0 172.17.0.47:3128 172.17.0.0/24 172.17.0.0/24,172.18.0.0/24 ccsadmin asecretpassword ccsmonitor asecretpassword"
	echo " "
	echo "ccsadmin and ccsmonitor passwords may be stored in \\trafs01a.ccs.local\shared\passwordsafe\continuum.psafe3"
	exit 1
fi
proxy_ip_and_port=$1
comma_separated_data_client_addresses=$2
comma_separated_management_client_addresses=$3
admin_user_name=$4
admin_user_password=$5
monitor_user_name=$6
monitor_user_password=$7

echo '# Configure http proxy for this bash session if applicable - asumes the same one for both http and https'
if [ "$proxy_ip_and_port" != 'n\a' ]; then
	export http_proxy=http://$proxy_ip_and_port
	export https_proxy=http://$proxy_ip_and_port
fi

echo '# RabbitMQ'
echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
cd ~
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
apt-get update
apt-get install rabbitmq-server -y --force-yes
# Management plugin - See http://www.rabbitmq.com/management.html
rabbitmq-plugins enable rabbitmq_management
service rabbitmq-server restart

echo '# Firewall rules'
data_client_address_array=(${comma_separated_data_client_addresses//,/ })
for client_address in "${data_client_address_array[@]}"
do
	ufw allow from $client_address to any proto tcp port 5672			# RabbitMQ
done
management_client_address_array=(${comma_separated_management_client_addresses//,/ })
for client_address in "${management_client_address_array[@]}"
do
	ufw allow from $client_address to any proto tcp port 15672			# RabbitMQ management
done

echo '# Setting up non default administrator and removing default administrator'
rabbitmqctl add_user $admin_user_name "$admin_user_password"
rabbitmqctl set_user_tags $admin_user_name administrator
rabbitmqctl set_permissions $admin_user_name '.*' '.*' '.*'
rabbitmqctl delete_user guest

echo '# Setting up monitoring user'
rabbitmqctl add_user $monitor_user_name "$monitor_user_password"
rabbitmqctl set_user_tags $monitor_user_name monitoring
rabbitmqctl set_permissions $monitor_user_name '^$' '^$' '.*'

echo '# Lock package'
echo rabbitmq-server hold | dpkg --set-selections

echo '# Clean up - script generated content only'
cd ~
rm rabbitmq-signing-key-public.asc
