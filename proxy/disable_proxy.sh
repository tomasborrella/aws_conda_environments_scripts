# env
unset http_proxy
unset https_proxy
unset ftp_proxy
export no_proxy="127.0.0.1;localhost"

unset HTTP_PROXY
unset HTTPS_PROXY
unset FTP_PROXY
export NO_PROXY="127.0.0.1;localhost"

# apt
sudo truncate -s 0 /etc/apt/apt.conf.d/30proxy

# conda
conda config --remove-key proxy_servers.http 2> /dev/null
conda config --remove-key proxy_servers.https 2> /dev/null

# docker
sudo truncate -s 0 /etc/systemd/system/docker.service.d/http-proxy.conf
sudo truncate -s 0 /etc/systemd/system/docker.service.d/https-proxy.conf

sudo systemctl daemon-reload
sudo systemctl restart docker

# git
git config --global --unset http.proxy

# dns
sudo truncate -s 0 /etc/resolvconf/resolv.conf.d/head
sudo resolvconf -u
