# DDH-OneTrueBox
An Ansible playbook for provisioning a VirtualBox VM with data-science tools for Digital Humanities.

Start by putting a [minimal Ubuntu 16.04 installation](https://help.ubuntu.com/community/Installation/MinimalCD) on a VirtualBox VM.
Create a user called "ubuntu" with password "ubuntu", forgo everything but basic system utilities, the OpenSSH server and the minimal XFCE desktop.
Set up port-forwarding on the VM in the "Advanced options" of the network settings:

| Name    | Host Port | Guest Port |
|---------|-----------|------------|
| SSH     | 8022      | 22         |
| Jupyter | 8888      | 8888       |

SSH into the VM: `ssh -p 8022 ubuntu@localhost`
Ansible just needs Python and the apt module: `sudo apt-get install python python-apt`
Since Ansible will only be acting on a local VM, security will be sacrificed for convenience.
Edit "/etc/sudoers" with `sudo visudo -f /etc/sudoers` and add the line `ubuntu ALL=(ALL) NOPASSWD:ALL`.

Log out of the VM, Ansible can do the rest. Grab the [cran module](https://github.com/yutannihilation/ansible-module-cran).
One more hideous concession to convenience: 'export ANSIBLE_HOST_KEY_CHECKING=False'
Finally, run the playbook: `ansible-playbook --module-path=./ansible-module-cran/library otb.yml`

For convenience, just build and run the Docker container:

```sudo docker build -t otb ddh-otb/DDH-OneTrueBox
sudo docker run --rm --net=host otb```
