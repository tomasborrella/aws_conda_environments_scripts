# Proxy Scripts

Bash scripts to configure Internet access through a proxy in a Linux system.

## Installation

No installation required, just place both files in a folder (I've used *~/scripts/proxy/* in the examples but you can choose the folder you want).

For your convenience you can include the folder to the system path and/or you can add a function to your *~/.bashrc* file (or *~/.zshrc*):

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

Depending of the options choosen during "installation" you can execute it in various ways:

1. Direct way (from the folder of the scripts): 
```code
./enable_proxy.sh
```
```code
./disable_proxy.sh
```

2. If proxy scripts folder have been added to the path:
```code
enable_proxy.sh
```
```code
disable_proxy.sh
```

3. If proxy function has been added to *.bashrc* (or *.zshrc*):
```code
proxy on
```
```code
proxy off
```
