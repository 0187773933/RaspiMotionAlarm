1. download 32bit ubuntu server image

   - https://ubuntu.com/download/raspberry-pi

2. balena etcher write image to sd card

   - https://www.balena.io/etcher/

3. unplug sd card , replug

4. open drive in terminal

5. `touch ssh`

6. unplug sd card, plug into raspi, boot raspi

7. ssh into raspi

   - https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#4-boot-ubuntu-server

   - default username = `ubuntu`
   - default password = `ubuntu`
   - It will make you change the password and then log you out.
   - just log back in after

8. Allow "simple" passwords

```bash
echo "password    [success=1 default=ignore]  pam_unix.so minlen=1 sha512
password    requisite           pam_deny.so
password    required            pam_permit.so" | sudo tee /etc/pam.d/common-password
```

9. Change root password

```bash
sudo passwd root
```

10. **TO FIX** Run git clone command to download everything and cd into git archive
11. Change into root user and run "./SCRIPTS/01_initial_setup.sh"

```bash
sudo su root
```

```bash
./SCRIPTS/01_initial_setup.sh
```

12. Copy Generated Private Key Somewhere Useful on Host Computer, like `nano /Users/morpheous/Documents/Misc/SSH2/KEYS/raspi-motion-alarm`

13. `chmod 600 /Users/morpheous/Documents/Misc/SSH2/KEYS/raspi-motion-alarm`

14. Create Utility ssh Script , and SSH Back into Raspi Under morphs

```bash
echo '#!/bin/bash
ssh -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no -o ServerAliveInterval=60 \
-o LogLevel=ERROR  -F /dev/null \
-i /Users/morpheous/Documents/Misc/SSH2/KEYS/raspi-motion-alarm \
morphs@192.168.1.105' | sudo tee /usr/local/bin/raspiMotionAlarmLocal && \
sudo chmod +x /usr/local/bin/raspiMotionAlarmLocal && \
/usr/local/bin/raspiMotionAlarmLocal
```

15. Run Post-Install Script "./TO/FIX/GIT/ARCHIVE/SCRIPTS/02_post_install.sh"

   - answer `yes` to "may disrupt ssh session"
   - answer `no` to "Override local changes to /etc/pam.d/common-*?"

16. Reboot

17. Build Docker Image

```bash
sudo docker rm motion-alarm -f || echo "" && sudo docker build -t motion-alarm .
```

18. Start Docker Image
```bash
sudo docker run -it \
--device "/dev/video0:/dev/video0" \
motion-alarm
```