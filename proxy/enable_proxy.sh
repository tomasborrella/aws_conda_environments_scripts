#!/bin/bash

# Path to configuration file
configuration=~/aws_conda_environments_scripts/proxy/default.cfg

# Load proxy variables from file
source $configuration

# ask for user credentials
if [ -z "${user}" ]; then
  stty -echo
  printf "[proxy] username: "
  read user
  stty echo
  printf "\n"
fi

stty -echo
printf "[proxy] password for $user: "
read pass
stty echo
printf "\n"

# env
export http_proxy="http://$user:$pass@$host:$port/"
export https_proxy="http://$user:$pass@$host:$port/"
export ftp_proxy="http://$user:$pass@$host:$port/"
export no_proxy="$no_proxy"

export HTTP_PROXY="http://$user:$pass@$host:$port/"
export HTTPS_PROXY="http://$user:$pass@$host:$port/"
export FTP_PROXY="http://$user:$pass@$host:$port/"
export NO_PROXY="$no_proxy"

# apt
echo "Acquire::http::proxy \"http://$user:$pass@$host:$port\";" | sudo tee -a /etc/apt/apt.conf.d/30proxy > /dev/null
echo "Acquire::https::proxy \"http://$user:$pass@$host:$port\";" | sudo tee -a /etc/apt/apt.conf.d/30proxy > /dev/null
echo "Acquire::ftp::proxy \"http://$user:$pass@$host:$port\";" | sudo tee -a /etc/apt/apt.conf.d/30proxy > /dev/null

# conda
conda config --set proxy_servers.http http://$user:$pass@$host:$port
conda config --set proxy_servers.https https://$user:$pass@$host:$port

# docker
echo -e "[Service]
Environment=\"HTTP_PROXY=http://$user:$pass@$host:$port/\" 
Environment=\"NO_PROXY=$host\"
" | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null

echo -e "[Service]
Environment=\"HTTPS_PROXY=http://$user:$pass@$host:$port/\" 
Environment=\"NO_PROXY=$host\" 
" | sudo tee /etc/systemd/system/docker.service.d/https-proxy.conf > /dev/null

sudo systemctl daemon-reload
sudo systemctl restart docker

# git
git config --global http.proxy http://$user:$pass@$host:$port

# dns
echo -e "nameserver 8.8.8.8
nameserver 8.8.8.4
" | sudo tee /etc/resolvconf/resolv.conf.d/head > /dev/null

sudo resolvconf -u
