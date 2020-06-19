# AWS Conda Environment Scripts

Scripts to facilitate working with Conda environments in the AWS Cloud.

## Objetive

Due to the corporate policy of the company I work for, 
AWS machines are created new every morning and therefore 
the working environment configurations we have created on them disappear. 

The aim of these scripts is to help us automate the creation of the working environment 
in a transparent way at the first connection of the day (SSH). 
This way, when other team members connect to the same machine they will find the system already configured.

The scripts are divided in three folders, one for each of the steps (detailed README in each folder):

## Step 0 - Configure proxy

You need an Internet connection so if you are behind a (corporate) proxy 
you can use the provided scripts to properly configure your local system to be able to access Internet:
[Proxy scripts](https://github.com/tomasborrella/aws_conda_environments_scripts/tree/master/proxy).

## Step 1 - Generate conda environments for AWS

Scripts to generate Conda environments for AWS machines in your local system using Docker:
[Generate Conda environments scripts](https://github.com/tomasborrella/aws_conda_environments_scripts/tree/master/docker_gen_conda_env)

## Step 2 - AWS Automatic environment deployment

Scripts to automatic deployment of Conda environments from S3 in the first ssh connection of the day:
[AWS deployment scripts](https://github.com/tomasborrella/aws_conda_environments_scripts/tree/master/aws)
