#!/usr/bin/env bash

echo 'Cleaning up tf files...'

sudo rm -rf terraform/
sudo rm -rf tf.plan

echo 'Running tf init...'
terraform init
terraform plan -out tf.plan
terraform apply tf.plan