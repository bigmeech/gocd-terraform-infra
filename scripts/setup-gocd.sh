#!/usr/bin/env bash

echo "Preparing Repository..."
echo "deb https://download.gocd.org /" | sudo tee /etc/apt/sources.list.d/gocd.list
curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo apt-key add -
sudo apt-get update

echo "Downloading Java 8..."
echo -ne '\n' | sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install -y openjdk-8-jre

echo "Downloading go server"
sudo apt-get install go-server
sudo /etc/init.d/go-server start