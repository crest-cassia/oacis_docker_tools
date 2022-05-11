# OACIS docker tools

A suite of scripts to use [OACIS docker](https://github.com/crest-cassia/oacis_docker).

## Basic Usage

### 1. Create a working directory anywhere you like.

```shell
$ mkdir oacis
$ cd oacis
```

### 2. Clone the oacis docker tools.

```shell
git clone https://github.com/crest-cassia/oacis_docker_tools.git
cd oacis_docker_tools
```

### 3. Start OACIS container

```shell
$ ./oacis_boot.sh
```

A container of OACIS launches. It takes some time until the launch completes.

- Visit http://localhost:3000 to access OACIS. You may change the port by specifying `-p` option.
- Visit http://localhost:8888 to access Jupyter notebook with OACIS API. The port may be changed by `-j` option.

See [OACIS documentation](http://crest-cassia.github.io/oacis/).

### 4. stopping the container temporarily

```shell
$ ./oacis_stop.sh
```

Even after the server is stopped, the data (including your simulation results) are not deleted. In other words, the virtual machine image still exists.
Restart the container by running `oacis_boot` again.

```shell
$ ./oacis_boot.sh
```

## Other commands

### stopping the container permanently

When you would like to remove the docker container as well as the docker volumes, run the following command:

```shell
$ ./oacis_terminate.sh
```

Note: **The database is deleted. Make sure to make a backup if you want to save your results somewhere.**

The simulation output files are stored in `Result` directory, which is not deleted by the above command. To delete all the files, remove `Result` directory as well.

```shell
$ rm -rf Result
```

### making a backup and restoring from it

When we would like to move all the data to other directory or make a backup, run the following command:
```shell
$ ./oacis_dump_db.sh
```
All the data stored in the database running on the container are dumped into `Result` directory.

After you run the above command, send `Result` directory to the place you like. For instance, run the following:
```shell
$ rsync -avhz --progress Result /path/to/backup
```

To restore the data from a backup, copy the backup to the `Result` directory first and then run the restore command.
Make sure that OACIS must be booted in advance.
```shell
$ ./oacis_boot.sh                # make sure that OACIS is running
$ rsync -avhz --progress /path/to/backup Result
$ ./oacis_restore_db.sh
```

### logging to the shell

When you would like to login to the shell on the docker container for trouble shooting, run the following command:

```shell
$ ./oacis_shell.sh
```


## SSH agent setup

On the container, you can use the SSH agent running on the *host OS*. If environemnt varialbe `SSH_AUTH_SOCK` is set in the host OS, the agent is mounted on the container.
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
The information required for SSH connection is determined by this file.


### 3. Add your key to the agent.

You'll be required to enter the passphrase for this key.

```shell
$ ssh-add ~/.ssh/id_rsa
```

Now you should be able to connect to a remote host wihtout entering a password.
Please test your connection from your host OS. You should be able to connect to a new shell without entering a password.

```shell
$ ssh localhost
```

### 4. Launch OACIS

When these set up are done, launch OACIS.

```shell
$ ./oacis_boot.sh
```

### 5. Register your host OS on OACIS

Go to the page of host list. Add a host with name **"docker-host"**. You'll be able to run your simulators on your host OS.
You may also register hosts listed on `~/.ssh/config`. Do not forget to set up [xsub](http://github.com/crest-cassia/xsub) on the remote hosts.

See the document for details: [How to setup host on OACIS](http://crest-cassia.github.io/oacis/en/configuring_host.html)

# License
oacis_docker_tools is a part of OACIS. OACIS is published under the term of the MIT License (MIT).
Copyright (c) 2014-2022 RIKEN AICS, RIKEN R-CCS

