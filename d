#!/bin/sh
# READ ONLY. This changes nothing at all - it only prints information so the
# fixes can be written correctly rather than guessed at.
echo "===== LOGIN SETTINGS ====="
sshd -T 2>/dev/null | grep -iE '^(passwordauthentication|permitrootlogin|pubkeyauthentication)' || \
  grep -ihE '^ *(PasswordAuthentication|PermitRootLogin)' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/* 2>/dev/null
echo
echo "===== WHAT SERVES THE AI ====="
systemctl list-units --type=service --state=running --no-pager 2>/dev/null | grep -viE 'systemd|dbus|cron|ssh|network|resolved|logind|getty|udev|timesync|journal|polkit|snap' | head -12
echo
echo "===== WEB SERVER CONFIG FILES ====="
ls /etc/nginx/sites-enabled/ 2>/dev/null || echo "(no nginx sites-enabled)"
echo
echo "===== ROUTES NGINX EXPOSES ====="
grep -rhE 'location|proxy_pass|server_name' /etc/nginx/sites-enabled/ 2>/dev/null | sed 's/^ *//' | head -25
echo
echo "===== WHERE THE APP LIVES ====="
for d in /opt /srv /home /var/www /root; do
  find "$d" -maxdepth 3 \( -name 'main.py' -o -name 'app.py' -o -name 'server.py' \) 2>/dev/null | head -5
done
echo
echo "===== DONE - nothing was changed ====="
