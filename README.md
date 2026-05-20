this is my infra setup for deploying my personal server on various cloud providers.

I tried to make it as reproducible and cloud provider agnostic as possible.

The components of infra are:

\# Terraform

- chose terraform for infra as code and version control my infra.
- separate terraform for each cloud provider, right now only azure and digitalocean supported.
- it configures resource group, subnetting, public ip, network security group, storage and vps instances.

\# NixOS

- nixos-anywhere to run nixos on any cloud provider regardless of whether the provider supports nixos or not.
- nixos makes everything reproducible by using declarative nix configs and lets me have machine as code and version control my os.
- agenix to manage secrets.
- disko to manage disk partitions.
- modules: - docker - bootstrap - nix - packages - secrets - security - shell - users

\# Services

- docker-compose automates and makes services reproducible.
- traefik as reverse proxy for services, perfectly designed for containers and auto ssl certs.
- hermes agent to automate fixes and updates for services.
- github action to `nixos-rebuild` and deploy changes to the server, whenever changes are pushed to infra/nixos.

\# backup

- restic with backblaze to backup all docker volumes.

\# structure

- infra/
  - nixos/ #nixos configuration
  - azure/ #terraform configuration for azure
  - digitalocean/ #terraform configuration for digitalocean
- scripts/ #scripts to automate infra tasks

\# usage

- choose cloud provider
- copy terraform.tfvars.example to terraform.tfvars and fill in the values for your cloud provider.
- run `terraform init` and `terraform apply` in the provider directory to deploy infra.
- run  `nixos-rebuild switch \
  --flake .#<azure|digitalocean> \
  --target-host root@<VPS_PUBLIC_IP> \
  --build-host localhost`   
  in infra/nixos directory.

\#todo

- [] add support for aws and gcp infra using terraform.
- [] nixos config for aws and gcp specific.
