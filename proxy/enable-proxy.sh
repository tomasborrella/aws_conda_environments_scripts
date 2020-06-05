#!/bin/bash

# varables
user=tbormar
host=10.113.55.36
port=8080
no_proxy="127.0.0.1,localhost,*.si.orange.es,10.35.254.*,10.118.194.12,10.118.226.86,crm-movil.orange.es,MXMEOCI1*,jazzfinan.jazztel.com*,10.118.212.241,10.118.208.68,10.118.240.81,10.0.124.228,10.0.248.*,10.148.36.65,62.14.44.27,10.113.90.95,10.0.254.30,ipcentrex.jazztel.com*,wfdp02ma02*,isr2pwm2.jazztel.com*,isr1pwm2.jazztel.com*,pdc.jazztel.com,10.113.67.10,90.160.44.212,10.113.44.*,ftp.icp.es,10.192.240.*,MXEC1CV1*,MXEC1CV2*,MXEC2CV1*,MXEC2CV2*,MXCOCA1*,MXCOCA2*,10.192.214.32,10.192.220.32,*jazzintegra*,*jzin61pw*,correoweb.orange.es,escudo.orange.es,10.132.200.*,*.enetres.net,*.ggcc.orange.es,10.113.64.52,*.conecta.orange.es,10.17.32.204,10.118.194.22,*.bender.orange.es"

# ask for user credentials
if [ -z "${user}" ]; then
    read "user?Enter COSMOS User: "
fi

stty -echo
printf "Enter COSMOS Password: "
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
echo -e "nameserver 10.159.255.197
nameserver 10.159.255.213
nameserver 10.159.131.2
" | sudo tee /etc/resolvconf/resolv.conf.d/head > /dev/null

sudo resolvconf -u
