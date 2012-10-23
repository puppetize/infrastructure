How to create the Vagrant base box "squeeze32" from scratch
===========================================================

1. Create a new virtual machine in VirtualBox, called "squeeze32".
2. Install Debian 6.0.6 (squeeze) from the first CD image.  Set the
   root password to "vagrant" and create a new user with username
   and password "vagrant".
3. Create a new group "admin" and add the "vagrant" user to it.
   ```
   # groupadd admin
   # usermod -G admin -a vagrant
   ```
4. Insert the CD image again.
5. Install the "sudo" package and configure it.
   ```
   # apt-get install sudo
   # echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/vagrant
   # echo '%admin ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/vagrant
   ```
6. Install the "openssh-server" package and add the insecure public key.
   ```
   # apt-get install openssh-server
   # sudo -u vagrant mkdir /home/vagrant/.ssh
   # sudo -u vagrant wget --no-check-certificate \
     -O/home/vagrant/.ssh/authorized_keys \
     https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
   ```
7. Install Puppet.
   ```
   # apt-get install puppet
   ```
8. Disable the CD-ROM package source in `/etc/apt/sources.list`. Otherwise
   Puppet will refuse to install packages.

9. Shut down the virtual machine and package it as a base box image. This
   will create a file called `package.box`.
   ```
   $ vagrant package --base squeeze32
   ```
10. Install the base box.
    ```
    $ vagrant box add squeeze32 package.box
    ```
