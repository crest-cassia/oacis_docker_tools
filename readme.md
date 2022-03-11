# OACIS docker tools

A suite of scripts to use [OACIS docker](https://github.com/crest-cassia/oacis_docker).

## Usage

### 1. Create a working directory anywhere you like.

```shell
$ mkdir oacis
$ cd oacis
```

### 2. Clone the oacis docker tools.

```shell
git clone https://github.com/crest-cassia/oacis_docker_tools.git
```

### 3. Start OACIS container

```shell
$ ./oacis_boot.sh
```

A container of OACIS launches. It takes some time until the launch completes.

You can access OACIS at http://localhost:3000. You may change the port by specifying `-p` option.
You can also access Jupyter notebook at http://localhost:8888, whose port may be changed by `-j` option.

### 4. stopping the container temporarily

```shell
$ ./oacis_stop.sh
```

Although the server is stopped, the data still exists.
You can restart the container by running `oacis_boot` again.

```shell
$ ./oacis_boot.sh
```

### 5. login to the shell

```shell
$ ./oacis_shell.sh
```


### 6. stopping the container permanently

```shell
$ ./oacis_terminate.sh
```


## SSH agent setup

On the container, you can use the SSH agent running on the host OS. If environemnt varialbe `SSH_AUTH_SOCK` is set in the host OS, the agent is mounted on the container.
Here is how to set up SSH agent on your host OS and use it on the container.

### 1. Create a key pair and add it to authorized_keys.

If you haven't made a SSH key-pair, create one in order to use it for your use.

```shell
$ ssh-keygen -t rsa
```

You may enter a passphrase when making a key-pair. The key pair will be created in `~/.ssh` directory.

If you are going to use the host OS as one of the remote hosts for OACIS, please set up as follows so that OACIS can connect to your host OS via SSH without entering password.
To do so, add this key to the list of `authorized_keys`. Make sure the permission of the `authorized_keys` is 600 when you make this file for the first time.

```shell
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
$ chmod 600 authorized_keys
```

### 2. Setup ssh-agent and ssh/.config

Set up ssh-agent on your host OS.
Launch SSH agent as follows. On macOS, SSH agent is automatically launched so you can skip this step.

```shell
$ eval $(ssh-agent)
Agent pid 97280
```

Edit `~/.ssh/config` file. This file is mounted on the container when running `oacis_boot.sh`.
The information required for SSH connection is determined by referring to this file.


### 3. Add your key to the agent.

You'll be required to enter the passphrase for this key.

```shell
$ ssh-add ~/.ssh/id_rsa
```

Now you should be able to connect to a remote host wihtout entering a password.
Please test your connection from your host OS.

```shell
$ ssh localhost
```

### 4. Launch OACIS

When these set up are done, launch OACIS.

```shell
$ ./oacis_boot.sh
```

### 5. Register your host OS on OACIS

Go to the page of host list. Add a host with name "docker-host". You'll be able to run your simulators on your host OS.
You may also register hosts listed on `~/.ssh/config`. Do not forget to set up [xsub](http://github.com/crest-cassia/xsub) on the remote hosts.

# License
oacis_docker_tools is a part of OACIS. OACIS is published under the term of the MIT License (MIT).
Copyright (c) 2014-2022 RIKEN AICS, RIKEN R-CCS

