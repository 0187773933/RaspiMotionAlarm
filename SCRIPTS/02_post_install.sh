#!/bin/bash
echo '
case $- in
	*i*) ;;
	  *) return;;
esac
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
	else
	color_prompt=
	fi
fi
RED="\[$(tput setaf 1)\]"
GREEN="\[$(tput setaf 2)\]"
YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
MAGENTA="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
RESET="\[$(tput sgr0)\]"
if [ "$color_prompt" = yes ]; then
	PS1="${GREEN}[\W]${RESET}${RED}@${RESET}${BLUE}\h${RESET}\n${MAGENTA}~~>${RESET} "
else
	PS1="${GREEN}[\W]${RESET}${RED}@${RESET}${BLUE}\h${RESET}\n${MAGENTA}~~>${RESET} "
fi
unset color_prompt force_color_prompt
case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*)
	;;
esac
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi' | tee ~/.bashrc

sudo apt-get install ufw -y
echo '#/etc/default/ufw
IPV6=no
DEFAULT_INPUT_POLICY="DROP"
DEFAULT_OUTPUT_POLICY="ACCEPT"
DEFAULT_FORWARD_POLICY="DROP"
DEFAULT_APPLICATION_POLICY="SKIP"
MANAGE_BUILTINS=no
IPT_SYSCTL=/etc/ufw/sysctl.conf
IPT_MODULES="nf_conntrack_ftp nf_nat_ftp nf_conntrack_netbios_ns"' | sudo tee /etc/default/ufw
sudo ufw reload
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status

echo '#!/bin/bash
rm -f ./.git/index.lock
git reset --hard HEAD
git clean -f
git pull origin master' | sudo tee /usr/local/bin/gitPullForce
sudo chmod +x /usr/local/bin/gitPullForce

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install net-tools -y
sudo apt-get install unzip -y
sudo apt-get install build-essential -y
sudo apt-get install software-properties-common -y

sudo apt-get install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
#sudo systemctl status fail2ban

sudo apt-get install python-pip -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-venv -y
sudo apt-get install libffi-dev -y
sudo apt-get install build-essential -y
sudo apt-get install python3-dev -y
sudo apt-get install python3-setuptools -y
sudo apt-get install python3-smbus -y
sudo apt-get install libncursesw5-dev -y
sudo apt-get install libgdbm-dev -y
sudo apt-get install libc6-dev -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install libsqlite3-dev -y
sudo apt-get install tk-dev -y
sudo apt-get install libssl-dev -y
sudo apt-get install openssl -y
sudo apt-get install libffi-dev -y
sudo apt-get install curl -y
sudo apt-get install wget -y

# https://github.com/pyenv/pyenv/blob/master/plugins/python-build/bin/pyenv-install
# https://github.com/pyenv/pyenv-installer
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
exec $SHELL
# PYENV_BUILD_ROOT=/home/morphs/DOCKER_IMAGES/RaspiMotionAlarm/PythonVersion/ pyenv install 3.7.3 -k
# nano ~/.bashrc
# export PATH=$PATH:/usr/local/go/bin
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
# eval "$(pyenv virtualenv-init -)"

## Docker Stuff
sudo apt-get install docker.io -y
sudo apt-get install docker-compose -y
echo '#!/bin/bash
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi $( sudo docker images -a -q )' | sudo tee /usr/local/bin/dockerDeleteAll
sudo chmod +x /usr/local/bin/dockerDeleteAll
echo "#!/bin/bash
sudo docker images | grep none | awk '{ print $3; }' | xargs sudo docker rmi -f
echo yes | sudo docker image prune -a
sudo docker rmi $(sudo docker images -f 'dangling=true' -q) -f
sudo docker rmi $(sudo docker images | grep '^<none' | awk '{print $3}')
sudo docker rmi $(sudo docker images | grep "none" | awk '{print $3}')" | sudo tee /usr/local/bin/dockerDeleteNoneImages
sudo chmod +x /usr/local/bin/dockerDeleteNoneImages

## Install Redis
# https://hub.docker.com/r/arm64v8/redis/
echo "vm.overcommit_memory = 1" | sudo tee -a /etc/sysctl.conf
mkdir -p /home/morphs/REDIS_PUBLIC
sudo chmod 777 /home/morphs/REDIS_PUBLIC
sudo chown -R morphs:sudo /home/morphs/REDIS_PUBLIC
sudo docker run -dit --restart='always' \
--name redis -p 6379:6379 \
-v /home/morphs/REDIS_PUBLIC/:/bitnami/redis/data \
arm32v7/redis:latest
# arm64v8/redis:latest
# -e REDIS_PASSWORD=c58054ae0db67ead0a7ecb9884aadc1e6e3cb3dc \
# bitnami/redis:latest
sudo ufw allow 6379
sudo apt-get install redis-tools -y

## Add Raspi-Camera-UDEV Rules
# echo 'SUBSYSTEM=="vchiq",MODE="0666"' | sudo tee /etc/udev/rules.d/99-camera.rules

## Enable Raspi Camera
echo "start_x=1" | sudo tee -a /boot/firmware/config.txt