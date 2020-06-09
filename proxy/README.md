# Proxy Scripts

Bash scripts to configure Internet access through a proxy in a Linux system (Debian-based Linux distros: Ubuntu, Mint ,...).

## Prerequisites

Script to enable proxy tries to configure several applications:
  - apt
  - conda
  - docker (for systems with *systemctl*)
  - git
  - resolvconf 
 
If you do not use any of these applications in your system you can comment out this lines.

## Installation

No installation required, just place both files in a folder (I've used *~/scripts/proxy/* in the examples but you can choose the folder you want).

For your convenience you can add a function to your *~/.bashrc* file (or *~/.zshrc*) like the following:

```code
proxy() {
  if [ $# -ne 1 ]; then printf "Usage: \"proxy on\" or \"proxy off\"\n" && return 1; fi

  case "$1" in
  on)
    source ~/scripts/proxy/enable_proxy.sh ;;
  off)
    source ~/scripts/proxy/disable_proxy.sh ;;
  *)
    printf "Usage: \"proxy on\" or \"proxy off\"\n" && return 1 ;;
  esac
}
```

## Configuration

You have to edit at least 2 variables inside *enable_proxy.sh* script:
  - host (IP address of the proxy)
  - port (Port of the proxy)

If the user of your system is different of the proxy user, you should add a *user* variable:
```code
user=<proxy_user>
```

You can also edit *no_proxy* variable to add the address you don't want to use proxy for.

And, at last, you can edit *dns* settings if you want to add custom nameserves once you connect to the proxy.

## Usage instructions

You can execute the scripts using *source* (with apropiate path):
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
