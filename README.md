### GOCD Installation

The repo contains code to install a fully working GOCD Server configured to run an Elastic Docker Agent

### Setup
- Run `./setup.sh` to generate ssh keys required by terraform provisioner
- Create `terraform.tfvars` file in the project root and set values for `aws region` and credentials `profile` (if you 
dont have one then create one in `~/.aws/credentials`)
- Run `./install.sh` to deploy infrastructure

### Test SSH Connection
Our terraform exports the command required to ssh into our provisioned EC2 Instance using the export variable