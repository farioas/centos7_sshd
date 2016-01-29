FROM centos:7.2.1511
MAINTAINER Sergey Zhuk <farioas@gmail.com>

ENV SUDO_USER centos
ENV AUTHORIZED_KEYS **None**

RUN yum -q -y install epel-release && \
    yum -q -y install sudo iproute openssh-server && \
    ssh-keygen -A && \
    yum clean all && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config

RUN useradd -d /home/$SUDO_USER -m -s /bin/bash $SUDO_USER && \
    echo $SUDO_USER:$SUDO_USER | chpasswd && \
    echo "$SUDO_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 22
CMD ["/run.sh"]