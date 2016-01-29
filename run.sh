#!/bin/bash

instance_ip=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    mkdir -p /home/$SUDO_USER/.ssh
    chmod 700 /home/$SUDO_USER/.ssh
    touch /home/$SUDO_USER/.ssh/authorized_keys
    chmod 600 /home/$SUDO_USER/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /home/$SUDO_USER/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /home/$SUDO_USER/.ssh/authorized_keys: $x"
            echo "$x" >> /home/$SUDO_USER/.ssh/authorized_keys
        fi
    done
    chown -R centos:centos /home/$SUDO_USER
    echo "========================================================================"
    echo "You can now connect to this CentOS container via SSH using ssh-key:"
    echo ""
    echo "    ssh -p <port> -i <private_key> $SUDO_USER@${instance_ip}"
    echo ""
    echo "========================================================================"
elif [ ! -f /.root_pw_set ]; then
    echo "=> no authorized keys provided"
    if [ -f /.root_pw_set ]; then
      echo "$SUDO_USER password already set!"
      exit 0
    fi

    PASS=${ROOT_PASS:-$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 10 | tr -d '\n'; echo)}
    _word=$( [ ${ROOT_PASS} ] && echo "preset" || echo "random" )
    echo "=> Setting a ${_word} password to the $SUDO_USER user"
    echo "$SUDO_USER:$PASS" | chpasswd

    echo "=> Done!"
    touch /.root_pw_set

    echo "========================================================================"
    echo "You can now connect to this CentOS container via SSH using password:"
    echo ""
    echo "    ssh -p <port> $SUDO_USER@${instance_ip}"
    echo "and enter the '$SUDO_USER' password '$PASS' when prompted"
    echo ""
    echo "Please remember to change the above password as soon as possible!"
    echo "========================================================================"
fi

exec /usr/sbin/sshd -D