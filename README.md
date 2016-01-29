# centos7_sshd

Usage
-----

To create the image `centos7_sshd`, execute the following commands on the `centos7_sshd` repository folder:

```bash
  docker build -t centos7_sshd .
```

Running centos7_sshd
--------------------

Run a container from the image you created earlier:

```bash
  docker run -d centos7_sshd
```

The first time that you run your container, a random password will be generated
for user `centos`. To get the password, check the logs of the container by running:

```bash
  docker logs <CONTAINER_ID>
```

You will see an output like the following:

```bash
=> no authorized keys provided
=> Setting a random password to the centos user
=> Done!
========================================================================
You can now connect to this CentOS container via SSH using password:

    ssh -p <port> centos@172.17.0.3
and enter the 'centos' password 'WlDtTZKCT5' when prompted

Please remember to change the above password as soon as possible!
========================================================================
```
In this case, `WlDtTZKCT5` is the password allocated to the `centos` user.

Done!


Setting a specific password for the centos account
------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `ROOT_PASS` to your specific password when running the container:

```bash
  docker run -d -e ROOT_PASS="mypass" centos7_sshd
```

Adding SSH authorized keys
--------------------------

If you want to use your SSH key to login, you can use the `AUTHORIZED_KEYS` environment variable. You can add more than one public key separating them by `,`:

```bash
docker run -d -e AUTHORIZED_KEYS="`cat ~/.ssh/id_rsa.pub`" centos7_sshd
```