# Generate Conda environments scripts

Using this scripts you can generate a Conda environment suitable for AWS machines in your local system using Docker.

## Prerequisites

You need **Docker** installed in your System (version >= 19.XX) and your user should be member of *docker* group 
(to be able to manage containers build without using *sudo*). To add your user to *docker* group, execute:
```code
sudo gpasswd -a $(whoami) docker
newgrp docker
```

## Installation

No installation needed. Just put the three files in the same folder:

 - gen_env.sh
 - Dockerfile
 - environment.yml

## Configuration

First you need to edit *environment.yml* to add your environment dependencies. This is an example:
```code
name: test_env
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.7
  - numpy
  - pandas
  - conda-pack
  - pip
```
Note: You can choose the channels you want and also the dependencies you need, but it is important to keep *conda-pack* 
because it is needed to be able to pack the environment once generated.

If you need to install packages from **PyPi** instead of Conda you can add that packages in this way:
```code
name: test_env2
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.6
  - conda-pack
  - pip
  - jupytext
  - pip:
    - shap==0.21.0
    - requests
    - sanic_prometheus==0.1.3
```

## Usage instructions

To create an environment that can be used in AWS (AwsLinux OS) just have to execute the following:
```code
./gen_env.sh
```

Once the process is finished the environment will be available as a *.tar.gz* archive in the same folder.

Note: If we are behind a proxy we have to pass the configuration as an argument, because
the container we are building needs Internet connection to download packages. You have to indicate -p parameter (proxy)
and adding user, proxy and port as comma separated values. For example:
```code
./gen_env.sh -p proxy_user,proxy_host,proxy_port
```

If we also want to install in our local system an environment with the same packages (and the same name) that the one
generated for AWS we have to include *-l* parameter (local).

This is the complete help of the script with all the options:
```code
./gen_env.sh -h
gen_env.sh - create conda package in a docker container
 
The script needs two files to run (in execution folder):
» environment.yml
» Dockerfile
 
options:
-h -- print help
-p -- proxy parameters (comma separated)
-l -- flag for local instalation
 
example:
gen_env.sh -p USER,HOST,PORT -l
```