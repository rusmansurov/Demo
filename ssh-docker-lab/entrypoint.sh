#!/bin/bash
# Копируем публичный ключ, если он есть
if [ -f /tmp/sshkey.pub ]; then
    cat /tmp/sshkey.pub >> /home/sshuser/.ssh/authorized_keys
    chmod 600 /home/sshuser/.ssh/authorized_keys
    chown -R sshuser:sshuser /home/sshuser/.ssh
fi

# Запускаем SSH
/usr/sbin/sshd -D
