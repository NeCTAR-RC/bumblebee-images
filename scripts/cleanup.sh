#!/bin/bash

# Clean up leftover build files
rm -fr /home/*/{.ssh,.ansible,.cache}
rm -fr /root/{.ssh,.ansible,.cache}
rm -fr /root/'~'*

# Truncate any log files
find /var/log -type f -print0 | xargs -0 truncate -s0

# Truncate resolv.conf if it exists
truncate -c -s 0 /etc/resolv.conf

# Clean up Ubuntu user
userdel -rf ubuntu || true
userdel -rf ec2-user || true

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync
