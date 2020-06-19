# Proxy Scripts

Bash scripts to configure Internet access through a proxy in a Linux system (Debian-based Linux distros: Ubuntu, Mint ,...).

## Prerequisites

Script to enable proxy tries to configure several applications:
  - apt
  - conda
  - docker (for systems with *systemctl*)
  - git
  - DNS (for systems with *resolvconf*)
 
If you do not use any of these applications in your system you can comment out this lines in *enable_proxy.sh* file.

## Installation

No installation required, just place both files in a folder (I've used *~/aws_conda_environments_scripts/proxy* 
in the examples considering the path of the cloned repo but you can choose the folder you prefer).

For your convenience you can add a function to your *~/.bashrc* file (or *~/.zshrc*) like the following:

```code
proxy() {
  if [ $# -ne 1 ]; then printf "Usage: \"proxy on\" or \"proxy off\"\n" && return 1; fi

  case "$1" in
  on)
    source ~/aws_conda_environments_scripts/proxy/enable_proxy.sh ;;
  off)
    source ~/aws_conda_environments_scripts/proxy/disable_proxy.sh ;;
  *)
    printf "Usage: \"proxy on\" or \"proxy off\"\n" && return 1 ;;
  esac
}
```

## Configuration

There is a configuration file *default.cfg*. You have to edit at least 2 variables inside that file:
  - host (IP address of the proxy)
  - port (Port of the proxy)

If you want that the script don't ask for proxy user, you can set *user* variable:
```code
user=<proxy_user>
```

You can also edit *no_proxy* variable to add the address you don't want to use proxy for.

And, at last, you can edit *nameservers* array if you want to add custom nameserves once you connect to the proxy.

**IMPORTANT NOTE**: If your scripts path is not *~/aws_conda_environments_scripts/proxy* you should modify
*enable_proxy.sh* to set the path of the configuration file (absolute).

## Usage instructions

You can execute the scripts using *source* (with appropriate path):
```code
source enable_proxy.sh
```
```code
source disable_proxy.sh
```

Or if proxy function has been added to *.bashrc* (or *.zshrc*) you can execute:
```code
proxy on
```
```code
proxy off
```
