FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    && mkdir /var/run/sshd

# Создаём пользователя sshuser
RUN useradd -ms /bin/bash sshuser && echo "sshuser:password" | chpasswd && adduser sshuser sudo

# Разрешаем вход по ключу
RUN mkdir -p /home/sshuser/.ssh && chmod 700 /home/sshuser/.ssh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]
