### GOCD Installation

The repo contains code to install a fully working GOCD Server configured to run an Elastic Docker Agent

### Setup
- Run `./setup.sh` to generate ssh keys required by terraform provisioner
- Create `terraform.tfvars` file in the project root and set values for `aws region` and credentials `profile` (if you 
dont have one then create one in `~/.aws/credentials`)
- Run `./install.sh` to deploy infrastructure

### Terraform exports

|Variable|Purpose|
|---------------|-----------------------------------------------------------------|
| ssh_connection| Displays command needed to ssh into the provisioned EC2 Instance|
|go_server_url| Public DNS of the provisioned instance|
|domain| Domain to attach TLS Certiicate for Go
| ec2_instance_size | EC2 Instance size 