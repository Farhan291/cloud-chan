#!/usr/bin/env bash

export B2_ACCOUNT_ID="YOUR_KEY_ID"
export B2_ACCOUNT_KEY="YOUR_APPLICATION_KEY"
export RESTIC_PASSWORD="YOUR_BACKUP_PASSWORD"

REPO="b2:your-bucket:/backup"

restic -r "$REPO" backup \
/var/lib/docker/volumes \
/srv/secrets

restic -r "$REPO" forget --keep-last 7 --keep-weekly 4 --prune
