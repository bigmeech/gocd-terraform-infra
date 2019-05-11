mkdir -p ./ssh
ssh-keygen -m PEM -t rsa -b 4096 -C "denachural@gmail.com" -f ./ssh/instance_keypair -P ""
sudo openssl rsa -text -in ./ssh/instance_keypair -outform pem > ./ssh/instance_keypair.pem
chmod 400 ./ssh/instance_keypair.pem