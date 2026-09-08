#!/bin/sh
K='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICX5vhSIFWTOYkpm9AlrEEXKaOAgP3VoI467V6pF84lp anirudha@worker'
if id deploy >/dev/null 2>&1; then
  U=deploy
else
  echo "NO deploy ACCOUNT ON THIS SERVER - nothing has been changed."
  echo "The normal accounts on this machine are:"
  awk -F: '$3>=1000 && $3<65534 {print "   " $1}' /etc/passwd
  echo "Send Anirudha that list and he will tell you the next step."
  exit 0
fi
mkdir -p "/home/$U/.ssh"
touch "/home/$U/.ssh/authorized_keys"
grep -qF "$K" "/home/$U/.ssh/authorized_keys" || echo "$K" >> "/home/$U/.ssh/authorized_keys"
chown -R "$U:$U" "/home/$U/.ssh"
chmod 700 "/home/$U/.ssh"
chmod 600 "/home/$U/.ssh/authorized_keys"
echo "DONE - key installed for $U"
