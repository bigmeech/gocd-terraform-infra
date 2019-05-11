### GOCD Installation

The repo contains code to install a fully working GOCD Server configured to run an Elastic Docker Agent

### Setup
- run `./setup.sh` to generate ssh keys required by terraform to run the provisioner command
- Create `terraform.tfvars` file in the project root and set values for `aws region` and credentials `profile` (if you 
dont have one then create one in `~/.aws/credentials`)