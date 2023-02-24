#!/bin/bash -e
################################################################################
##  File:  sonarqube.sh
##  Desc:  Installs sonarqube onto the image
################################################################################

docker pull sonarqube:lts-community

echo 'vm.max_map_count=524288' >> /etc/sysctl.conf
echo 'fs.file-max=131072' >> /etc/sysctl.conf
echo '* soft nofile 655360' >> /etc/security/limits.conf
echo '* hard nofile 655360' >> /etc/security/limits.conf
 
cd /home/adminaz
mkdir -p /home/adminaz/sonarqube_extensions/plugins
wget -O /home/adminaz/sonarqube_extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/1.14.0/sonarqube-community-branch-plugin-1.14.0.jar
wget -O /home/adminaz/sonarqube_extensions/plugins/community-rust-plugin-0.1.4.jar  https://github.com/elegoff/sonar-rust/releases/download/v0.1.4/community-rust-plugin-0.1.4.jar

cp /imagegeneration/installers/sonarqube/docker-compose.yml .
docker compose up -d
