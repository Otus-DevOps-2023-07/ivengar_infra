#!/bin/bash -x

yc compute instance create \
  --name reddit-app-full \
  --hostname reddit-app \
  --zone=ru-central1-a \
  --create-boot-disk size=20GB,image-id=fd8fp6gf9d7thhsoheub \
  --cores=2 \
  --core-fraction=20 \
  --memory=4G \
  --network-interface subnet-id=e9b24d2brea26rc2tc3a,ipv4-address=auto,nat-ip-version=ipv4
