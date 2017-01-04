# DDH-OneTrueBox
An Ansible playbook for provisioning a VirtualBox VM with data-science tools for Digital Humanities.

Distributing data-science tools to end-users with limited computing experience can be a problem.
The book ["Mining the Social Web"](https://github.com/ptwobrussell/Mining-the-Social-Web-2nd-Edition) provides a Vagrant image for
making its various Ipython/Jupyter notebooks and the libraries they require available, but this requires some familiarity with the
commandline, which could intimidate users before they run a single line of code. Experience has shown that novice users are quite
capable of installing [VirtualBox](https://www.virtualbox.org/) and importing and launching appliances, however. For browser-based
tools like [Jupyter](http://jupyter.org/) and [Rstudio Server](https://www.rstudio.com/products/rstudio/download-server/),
[Docker](https://www.docker.com/) is a convenient tool for managing libraries and their depenendices, as shown by the popular
[Hadleyverse image](https://github.com/rocker-org/hadleyverse). However, Docker is not particularly suitable for novice users.
The current version of [Docker for Windows](https://docs.docker.com/docker-for-windows/) has very narrow requirements, in any case,
the legacy [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) is based on VirtualBox anyway. A solution
is to package a Docker image in a minimal VirtualBox that is launched on booting. Although this approach can yield a convenient
browser-based environment for Python and R, if desktop applications such as [QGIS](http://www.qgis.org/en/site/) are required it
makes more sense to install software on the VirtualBox VM directly. While perhaps rather more brittle than Docker,
[Ansible](https://www.ansible.com/) provides a means for specifying and documenting the VM. The ability to clone, snapshot and
restore VirtualBox VMs may make it a more flexible solution than installing a complete Anaconda distribution.

## Using the VM.

All a user need do is select "import appliance" from the VirtualBox file menu and click "start". A simple XFCE desktop will
appear with icons for [QGIS](http://www.qgis.org/en/site/), [Rstudio](https://www.rstudio.com/) and Spyder.
A [Jupyter Notebook](http://jupyter.org/) server will automatically be running at `http://localhost:8888`, with both Python3
and R kernels available.

## Building the VM.

Very little needs to be done to the VM by hand before Ansible can take over the process.
Start by putting a [minimal Ubuntu 16.04 installation](https://help.ubuntu.com/community/Installation/MinimalCD) on a VirtualBox VM.
Create a user called "ubuntu" with password "ubuntu", forgo everything but basic system utilities, the OpenSSH server and the minimal XFCE desktop.
Set up port-forwarding on the VM in the "Advanced options" of the network settings:

| Name    | Host Port | Guest Port |
|---------|-----------|------------|
| SSH     | 8022      | 22         |
| Jupyter | 8888      | 8888       |

SSH into the VM: `ssh -p 8022 ubuntu@localhost`.
Ansible just needs Python and the apt module: `sudo apt-get install python python-apt`.
Since Ansible will only be acting on a local VM, security will be sacrificed for convenience.
Edit "/etc/sudoers" with `sudo visudo -f /etc/sudoers` and add the line `ubuntu ALL=(ALL) NOPASSWD:ALL`.

Log out of the VM, Ansible can now do the rest. Grab the [cran module](https://github.com/yutannihilation/ansible-module-cran).
One more hideous concession to convenience: `export ANSIBLE_HOST_KEY_CHECKING=False`
Finally, run the playbook: `ansible-playbook --module-path=./ansible-module-cran/library otb.yml`

For convenience, just build and run the Docker container:

```
sudo docker build -t otb ddh-otb/DDH-OneTrueBox

sudo docker run --rm --net=host otb
```
