#!/usr/bin/env bash

##
# Bash script to provision VM.
# Add one time machine set up here.
#
# Be aware this script is only the first time you issue the
#    vagrant up
# command, or following a
#    vagrant destroy
#    vagrant up
# combination.  See the README for further detais.
##

##
# Update apt repo
# force yes install of unzip, tomcat7, & openjdk
##
apt-get update
apt-get install -y unzip tomcat7 openjdk-6-jdk ant tcpdump

##
# Get the axis war and install under tomcat 
##
mkdir -p /tmp/axis
cd /tmp/axis
wget http://www.mirrorservice.org/sites/ftp.apache.org//axis/axis2/java/core/1.6.2/axis2-1.6.2-war.zip
unzip axis2-1.6.2-war.zip
chown tomcat7:tomcat7 axis2.war
mv axis2.war /var/lib/tomcat7/webapps
service tomcat7 restart
cd ..
rm -rf axis

##
# Set the axis binary tools up under /home/vagrant, we'll need these tools
# to build the service and client
##
mkdir -p /home/vagrant/axis
cd /home/vagrant/axis
wget http://www.mirrorservice.org/sites/ftp.apache.org//axis/axis2/java/core/1.6.2/axis2-1.6.2-bin.zip
unzip axis2-1.6.2-bin.zip
rm axis2-1.6.2-bin.zip

##
# Now build the sample MTOM upload service and deploy it
##
cd /home/vagrant/axis/axis2-1.6.2/samples/mtom
ant generate.service
mv /home/vagrant/axis/axis2-1.6.2/repository/services/sample-mtom.aar /var/lib/tomcat7/webapps/axis2/WEB-INF/services/
service tomcat7 restart

##
# Build and run the service client
##
# Set up TCP Dump to listen and log to /tmp/MTOM.log
tcpdump -XX -i lo -w /tmp/MTOM.log &

## BUILD AND TUN THE CLIENT
ant run.client -Dfile "/vagrant/Vagrantfile" -Ddest "/tmp/MTOM-Vagrantfile"

# tidy up and cat the log
chown -R vagrant:vagrant /home/vagrant/axis
skill -TERM tcpdump
cat /tmp/MTOM.log 
