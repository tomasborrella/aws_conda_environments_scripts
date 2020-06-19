# AWS deployment scripts

*Work in progress*

## Prerequisites

Conda packed environments (.tar.gz) are available in S3.

You have configured your ssh client (*~/.ssh/config*) to be able to reach AWS machine/s by name and without password. 
If you don't have a public key configured (or are not able to resolve AWS machine name) you have to modify *ssh_aws.sh* 
script with your configuration.

## Installation

No installation needed. Just put the three files in the same folder:

 - aws_environments.sh
 - default.cfg
 - ssh_aws.sh

## Configuration

#### ssh_aws.sh

If your scripts path is not *~/aws_conda_environments_scripts/aws* (the resultant if the repo was cloned from the home of the user)
you should modify *ssh_aws.sh* to set the path of the configuration file *default.cfg* (absolute).
```code
# Path to default configuration file
default_configuration=~/aws_conda_environments_scripts/aws/default.cfg
```

#### default.cfg

If your scripts path is not *~/aws_conda_environments_scripts/aws* (the resultant if the repo was cloned from the home of the user)
you should modify *default.cfg* to set the path of the remote configuration script that is send to the remote system *aws_environments.sh* (absolute).
```code
### Local script path (absolute)
remote_envs_script=~/aws_conda_environments_scripts/aws/aws_environments.sh
```

Also you have to modify the following three variables:
```code
remote_host=change_this # aws machine ip or hostname
s3_root=change_this # bucket without s3://
s3_folder=change_this # prefix (folder) with conda packed environments
```

#### Path and alias

For your convenience you can add a the following to your *~/.bashrc* file (or *~/.zshrc*):
```code
# Add scripts folder to PATH
export PATH=$PATH:~/aws_conda_environments_scripts/aws
 
# Alias
alias ssh_aws="ssh_aws.sh"
```

## Usage instructions

To use the script you just have to execute *./ssh_aws.sh* (or just *ssh_aws* if you have added the alias of the previous section).
This is the output showing the help of the script:
```code
ssh_aws.sh - send a preparation script to aws and open a ssh connection with a tunnel
 
arguments:
1. Port to be tunneled (mandatory)
2. Configuration file (optional)
 
examples:
ssh_aws.sh 9798
ssh_aws.sh 9799 config_file
```

The only mandatory parameter is the port we want to tunnel, 
that will allow us to use remote jupyter notebooks in a really easy and convenient way.

The second parameter allows the user to have several config files for example to connect to different machines.

#### Use example

That's an example output of the first user connecting to a the AWS machine:
```code
ssh_aws 7979
 
Hi! You are the first user today. Preparing system...
 
> Downloading environments from S3 ✔
> Unpacking environments ✔
 
System ready!
 
+------------------------+
¦ AVAILABLE ENVIRONMENTS ¦
+------------------------+
 
  » test_env
  » test_env2
 
  Commands:
  --------
 
  ■ envs (show this info)
  ■ activate <envinonmet_name>
  ■ deactivate
 
  ■ jupyter
  ■ aws_s3_ls
```

The commands available from that moment in the remote system are:
 - envs: Show the information of available environments and commands (same message showed in the first connection).
 - activate <env_name>: Activate a Conda environment (it should be available and be showed in the previous list).
 - deactivate: Deactivate active Conda environment and return to system Python.
 - jupyter (with an active environment): Execute Jupyter notebook in the tunneled port specified during connection.
 - aws_s3_ls: List S3 files.
