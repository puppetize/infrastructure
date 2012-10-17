How to create the Vagrant base box "squeeze32" from scratch
===========================================================

1. Install Debian 6.0.6 (squeeze) from the first CD image.
2. Create a new group "admin" and add the vagrant user to it.
   # groupadd admin
   # useradd -G admin -a vagrant
3. Insert the CD image again.
4. Install the "sudo" package and configure it.
   # apt-get install sudo
   # echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/vagrant
   # echo '%admin ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/vagrant
5. Install the "openssh-server" package and add the insecure public key.
   # apt-get install openssh-server
   # sudo -u vagrant mkdir /home/vagrant/.ssh
   # sudo -u vagrant wget --no-check-certificate \
     -O/home/vagrant/.ssh/authorized_keys \
     https://raw.github.com/mitchellh/master/keys/vagrant.pub
6. Install Puppet.
   # apt-get install puppet
7. Disable the CD-ROM package source (otherwise, Puppet refuses to
   install packages).

Now package the base box with Vagrant:

# vagrant package --base squeeze32
