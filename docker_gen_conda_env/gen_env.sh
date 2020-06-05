#!/bin/bash

proxy=''
local_flag=''

print_usage() {
  printf "gen_env.sh - create conda package in a docker container\n\n"
  printf "The script needs two files to run (in execution folder):\n"
  printf "»  environment.yml\n"
  printf "»  Dockerfile\n\n"
  printf "options:\n"
  printf -- "-h -- print help\n"
  printf -- "-p -- proxy parameters (comma separated)\n"
  printf -- "-l -- flag for local instalation\n\n"
  printf "example:\n"
  printf "gen_env.sh -p USER,HOST,PORT -l\n"
}

# Check for needed files
if [ ! -f environment.yml ] || [ ! -f Dockerfile ]; then 
  print_usage
  exit 1
fi

# Get arguments
while getopts 'hp:l' flag; do
  case "${flag}" in
    p) set -f             # disable glob
       IFS=,              # split on comma
       proxy=($OPTARG) ;; # use the split+glob operator 
    l) local_flag='true' ;;
    h) print_usage
       exit 0 ;;
    *) print_usage
       exit 1 ;;
  esac
done

# Get proxy information

if [ ! -z "$proxy" ]; then
  if [ ${#proxy[@]} -ne 3 ]; then
    print_usage
    exit 1
  else
    user=${proxy[0]}
    host=${proxy[1]}
    port=${proxy[2]}

    # Ask for password
    stty -echo
    printf "Enter proxy password: "
    read pass
    stty echo
    printf "\n"
  fi
fi

# Build docker container and create environment  

if [ ! -z "$proxy" ]; then
  # Configure Docker service proxy
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

  # Build container with proxy arguments
  DOCKER_BUILDKIT=1 docker build \
  --build-arg http_proxy=http://$user:$pass@$host:$port/ \
  --build-arg https_proxy=http://$user:$pass@$host:$port/ \
  --file Dockerfile --output out .

  # Restore Docker Service proxy configuration 
  sudo truncate -s 0 /etc/systemd/system/docker.service.d/http-proxy.conf
  sudo truncate -s 0 /etc/systemd/system/docker.service.d/https-proxy.conf
    
  sudo systemctl daemon-reload
  sudo systemctl restart docker
else
  DOCKER_BUILDKIT=1 docker build --file Dockerfile --output out .
fi

# Get the name of the environment from environment.yml  
name=$(head -1 environment.yml | cut -d' ' -f2)

# Move the package to the execution folder, rename and clean
if [ -d out ]; then
  mv out/environment.tar.gz $name.tar.gz && rm -rf out 
  printf "Environment packed succesfully √\n"
fi

if [ ! -z "$local_flag" ]; then
  # Create local environment
  printf "\nCreating local environment...\n"  
  # Configure conda proxy  
  if [ ! -z "$proxy" ]; then
    conda config --set proxy_servers.http http://$user:$pass@$host:$port
    conda config --set proxy_servers.https https://$user:$pass@$host:$port
  fi
  # Create environment 
  conda env create -f environment.yml
fi
