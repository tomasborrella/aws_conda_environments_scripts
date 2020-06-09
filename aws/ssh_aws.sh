#!/bin/bash

# Path to default configuration file
default_configuration=~/aws_conda_environments_scripts/aws/default.cfg

print_usage() {
  printf "ssh_aws.sh - send a preparation script to aws and open a ssh connection with a tunnel\n\n"
  printf "arguments:\n"
  printf "1. Port to be tunneled (mandatory)\n"
  printf "2. Configuration file (optional)\n\n"
  printf "examples:\n"
  printf "ssh_aws.sh 9798\n"
  printf "ssh_aws.sh 9799 config_file\n" 
}

# Check parameters
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  print_usage
  exit 1
fi

port=$1

# Load configuration from file
if [ -z $2 ]; then
  source $default_configuration
else
  source $2
fi

# Check all needed configuration variables
error=0
if [ -z $remote_host ]; then
  printf "Check configuration. Variable \$remote_host not provided.\n" && error=1; fi

if [ -z $remote_envs_script ]; then
  printf "Check configuration. Variable \$remote_envs_script not provided.\n" && error=1; fi

if [ -z $environments_dir ]; then
  printf "Check configuration. Variable \$environments_dir not provided.\n" && error=1; fi

if [ -z $environments_dir_tmp ]; then
  printf "Check configuration. Variable \$environments_dir_tmp not provided.\n" && error=1; fi

if [ -z $s3_root ]; then
  printf "Check configuration. Variable \$s3_root not provided.\n" && error=1; fi

if [ -z $s3_folder ]; then
  printf "Check configuration. Variable \$s3_folder not provided.\n" && error=1; fi

# Exit if any of the configuration variables is missing
if ((error)); then exit 1; fi

# Execute script in remote host
ssh $remote_host "bash -s" < $remote_envs_script "$port $environments_dir $environments_dir_tmp $s3_root $s3_folder"

# ssh interactive connection with tunnel
ssh -L $port:$remote_host:$port $remote_host
