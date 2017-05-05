#!/usr/bin/env bash



# Set up vagrant user ssh keys. These need to live on the vms to have
# reasonable permissions with Windows and vboxsf
mkdir -p  "/home/vagrant/.ssh/machines"
for host in $(ls /vagrant/.vagrant/machines);
do
    [ ! -f "/vagrant/.vagrant/machines/${host}/virtualbox/private_key" ] && continue
    mkdir "/home/vagrant/.ssh/machines/${host}"
    cp -v "/vagrant/.vagrant/machines/${host}/virtualbox/private_key" "/home/vagrant/.ssh/machines/${host}"
    chmod 600 "/home/vagrant/.ssh/machines/${host}/private_key"
    chown -R vagrant:vagrant "/home/vagrant/.ssh/"
done

# Clean metadata in case of old mirrors etc
yum clean metadata
yum check-update

# Install git and ansible to get started
yum install -y epel-release
yum install -y git gcc openssl-devel python-devel python2-pip
pip install 'ansible==2.1.1'

# Create the default ansible config folder (pip install doesn't).
mkdir -pv /etc/ansible

# create ansible vault secret if one doesn't exist.
stat /vagrant/vault_password.txt &>/dev/null || bash -c '< /dev/urandom tr -dc "a-zA-Z0-9~!@#$%^&*_-" | head -c${1:-254};echo;' > /vagrant/vault_password.txt

# copy hosts file provided by vagrant provisioner
cp /vagrant/ansible.hosts /etc/ansible/hosts
cp /vagrant/ssh.cfg /home/vagrant/.ssh/config
chown vagrant:vagrant /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config

# ansible complains if this file is on the windows share because permissions
cp /vagrant/ansible.cfg /etc/ansible/ansible.cfg
chown root:wheel /etc/ansible/ansible.cfg
chmod 644 /etc/ansible/ansible.cfg

# Install default ansible roles
VAGRANT_REQUIREMENTS='/vagrant/requirements.yml'
ansible-galaxy install -r "${VAGRANT_REQUIREMENTS}" --force

# run ansible
sudo -u vagrant bash -c "
# Keep colors intact
export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=1
export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg
ansible-playbook --inventory-file=/etc/ansible/hosts --user=vagrant /vagrant/playbooks/vagrant.yml
"
