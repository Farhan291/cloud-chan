# Cloud-Chan

Terraform configs and some scripts for my personal VPS.
## Why ?
i heavily relies on free cloud credits from azure, aws, gcp, digitalocean etc through my student programs. the credits expire and renew, so i constantly need to migrate my VPS from one provider to another,so instead of doing it manually every time, i automate with terraform.

all my actual projects live in their own git repos and run via docker compose. the only thing that needs moving between providers is the VM itself and some persistent data (docker volumes, databases, etc).

## How it works

1. **spin up a VPS** using terraform (pick whichever provider has credits right now)
2. **cloud-init** automatically installs docker, basic tools and sets up fail2ban.
3. **clone my project repos** and `docker compose up` — everything is back

that's it. no kubernetes, no fancy orchestration. just one small VPS running docker compose.

## Backup & migration strategy

i use [restic](https://restic.net/) + [backblaze B2](https://www.backblaze.com/cloud-storage) (free tier) for persistent data that isn't in git.

**what gets backed up with restic:**
- docker volumes (databases, uploads, etc)
- any config files not in git
- anything that would be painful to recreate

**what doesn't need backup:**
- application code (already in git, just clone again)
- docker images (just pull again)
- anything reproducible

### Restic + backblaze setup

```bash
# install restic
apt install restic

# init a repo on backblaze b2
export B2_ACCOUNT_ID="YOUR_KEY_ID"
export B2_ACCOUNT_KEY="YOUR_APPLICATION_KEY"
export RESTIC_PASSWORD="YOUR_BACKUP_PASSWORD"

restic -r b2:your-bucket:/backup init

# backup
restic -r b2:your-bucket:/backup backup /var/lib/docker/volumes

# restore on new VPS
restic -r b2:your-bucket:/backup restore latest --target /backup
```

backblaze B2 free tier gives you 10GB storage more than enough for a single VPS worth of persistent data.

## Usage

### 1. pick a provider and configure

```bash
cd infra/digitalocean   # or infra/azure

# copy and fill in your values
cp terraform.tfvars.example terraform.tfvars
```

### 2. spin up the VPS

```bash
terraform init
terraform plan
terraform apply
```

cloud-init will automatically install docker and basic tools. give it a couple minutes after the VM is up.

### 3. restore your data

ssh into the new VPS and run the command:

```bash
# set your backblaze creds
export B2_ACCOUNT_ID="..."
export B2_ACCOUNT_KEY="..."
export RESTIC_PASSWORD="..."

restic -r b2:your-bucket:/backup restore latest --target /backup 
```

### 4. start your projects

```bash
git clone <your-project-repo>
cd your-project
docker compose up -d
```
### 5. Backup current vps data

#### Copy the backup script and edit env vars
```bash
sudo cp cloud-chan/scripts/backup.sh /usr/local/bin/backup.sh 
sudo chmod +x /usr/local/bin/backup.
```

#### cron schedule
```bash
sudo crontab -e
# add this line to the crontab
0 3 * * * /usr/local/bin/backup.sh
```

## migration checklist

when credits expire and you need to move:

- [ ] backup persistent data with restic
- [ ] `terraform destroy` on the old provider
- [ ] `terraform apply` on the new provider
- [ ] restore data, clone repos, `docker compose up`
- [ ] update DNS if needed

## currently supported providers

- **azure** — student free credits
- **digitalocean** — github student pack credits

adding aws/gcp whenever i get around to it. the pattern is the same, just a VM with SSH, HTTP, HTTPS open and cloud-init to bootstrap docker.

## note

this is intentionally simple. it's one VPS running docker compose, not a production cluster. the goal is to make migration between providers take ~15 minutes instead of an hour of manual setup.
