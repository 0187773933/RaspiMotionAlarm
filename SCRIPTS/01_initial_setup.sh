#!/bin/bash
HostName="motionalarm"
NewSudoUserName="morphs"
NewSudoUserPassword="asdfasdf"
hostnamectl set-hostname "$HostName"
echo "PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
PrintMotd no
Banner none
AcceptEnv LANG LC_*
Subsystem   sftp    /usr/lib/openssh/sftp-server
ClientAliveInterval 3
#X11Forwarding no
#AllowTcpForwarding no
#PermitTTY no
#ForceCommand cvs server
GatewayPorts yes
PubkeyAuthentication yes" > /etc/ssh/sshd_config
systemctl reload sshd
useradd -m "$NewSudoUserName" -p "$NewSudoUserPassword" -s "/bin/bash"
mkdir -p /home/$NewSudoUserName
chown -R $NewSudoUserName:$NewSudoUserName /home/$NewSudoUserName
usermod -aG sudo $NewSudoUserName
echo "${NewSudoUserName} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
/bin/su -s /bin/bash -c 'mkdir -p ~/TMP2' $NewSudoUserName
echo "#!/bin/bash" > "/home/${NewSudoUserName}/TMP2/init.sh"
echo "mkdir -p /home/${NewSudoUserName}/.ssh" >> "/home/${NewSudoUserName}/TMP2/init.sh"
echo "chmod 700 /home/${NewSudoUserName}/.ssh" >> "/home/${NewSudoUserName}/TMP2/init.sh"
echo "ssh-keygen -t ed25519 -b 521 -a 100 -f '/home/${NewSudoUserName}/.ssh/$HostName' -q -N ''" >> "/home/${NewSudoUserName}/TMP2/init.sh"
echo "cat /home/${NewSudoUserName}/.ssh/${HostName}.pub > /home/${NewSudoUserName}/.ssh/authorized_keys" >> "/home/${NewSudoUserName}/TMP2/init.sh"
echo "chmod 600 /home/${NewSudoUserName}/.ssh/authorized_keys" >> "/home/${NewSudoUserName}/TMP2/init.sh"
/bin/su -s /bin/bash -c 'sudo chmod +x ~/TMP2/init.sh' $NewSudoUserName
/bin/su -s /bin/bash -c '~/TMP2/init.sh' $NewSudoUserName
cat "/home/${NewSudoUserName}/.ssh/${HostName}"

# Add Swap File
# allocate -l 1G /swapfile
# chmod 600 /swapfile
# mkswap /swapfile
# swapon /swapfile