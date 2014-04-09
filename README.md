axis-mtom
=========

Intro
-----

A quick build and run of an Axis2 MTOM service.

You'll need [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) installed (latest version of Vagrant).

Install
-------
```
vagrant up
```

What's Happened?
----------------
On first start up the VM:

 * Sets up a bare-bones Debian 7.4 wheezy instance.
 * Installs tomcat7, openJDK 6, and a few utils.
 * Downloads axis2-1.6.2 and installs under tomcat.
 * Builds the Axis2 MTOM sample service and installs under Axis2/Tomcat.
 * Builds the same sample's client and runs it, while logging the TCP traffic.

### A Little Detail
The set up is handled by the provisioning [bash scipt](setup.sh).

The client run command in the script is:

```
## BUILD AND TUN THE CLIENT
ant run.client -Dfile "/vagrant/Vagrantfile" -Ddest "/tmp/MTOM-Vagrantfile"
```
which is run in the 

```
/home/vagrant/axis/axis2-1.6.2/samples/mtom
```
directory. The uploaded file in the sample is just the [Vagrantfile](Vagrantfile), which is saved by the service to:

```
/tmp/MTOM-Vagrantfile
```
while the TCP traffic log is created by:

```
tcpdump -XX -i lo -w /tmp/MTOM.log
```

Can I See This?
---------------
Type ```vagrant ssh``` for command line access to the VM, or look on [localhost:8080](http://localhost:8080/axis2/services/listServices) to see the MTOMSample service.
