#!/usr/bin/env bash

ELASTIC_AGENT_VERSION="3.0.0"
ELASTIC_AGENT_BUILD_NUMBER="${ELASTIC_AGENT_VERSION}-222"
ELASTIC_AGENT_FILENAME="docker-elastic-agents-${ELASTIC_AGENT_BUILD_NUMBER}.jar"

echo "Preparing Repository..."
echo "deb https://download.gocd.org /" | sudo tee /etc/apt/sources.list.d/gocd.list
curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo apt-key add -
sudo apt-get update

echo "Downloading Java 8..."
echo -ne '\n' | sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install -y openjdk-8-jre

echo "Installing and starting go server"
sudo apt-get install go-server
sudo /etc/init.d/go-server start

echo "Installing Elastic Agent plugin"
wget "https://github.com/gocd-contrib/docker-elastic-agents/releases/download/v${ELASTIC_AGENT_BUILD_NUMBER}/${ELASTIC_AGENT_FILENAME}"
sudo mv $ELASTIC_AGENT_FILENAME "/var/lib/go-server/plugins/external/${ELASTIC_AGENT_FILENAME}"

echo "Restarting GO Server"
sudo /etc/init.d/go-server restart