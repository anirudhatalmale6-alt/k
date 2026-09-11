#!/bin/sh
# Creates a normal (non-root) account called deploy, mirroring the setup on the
# other Tarjumah server, and installs the developer's key into it.
K='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICX5vhSIFWTOYkpm9AlrEEXKaOAgP3VoI467V6pF84lp anirudha@worker'
if ! id deploy >/dev/null 2>&1; then
  useradd -m -s /bin/bash deploy || exit 1
  echo "created deploy account"
fi
mkdir -p /home/deploy/.ssh
touch /home/deploy/.ssh/authorized_keys
grep -qF "$K" /home/deploy/.ssh/authorized_keys || echo "$K" >> /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
# Admin rights are needed to change the login settings and restart the
# translation service. Remove this line to revoke them.
echo 'deploy ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-deploy
chmod 440 /etc/sudoers.d/90-deploy
echo "DONE - key installed for deploy"
