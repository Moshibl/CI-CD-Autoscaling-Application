#!/bin/bash
set -euo pipefail

cd ../Terraform
terraform output -json > ../Scripts/TF-Outputs.json
terraform output
MASTER_IP=$(terraform output -raw MASTER_IP)
SLAVE_IP=$(terraform output -raw SLAVE_IP)
KEY_PATH=$(realpath "$1")

cat > ~/.ssh/config <<EOF
Host master
  HostName ${MASTER_IP}
  User ubuntu
  IdentityFile ${KEY_PATH}
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null

Host slave
  HostName ${SLAVE_IP}
  User ubuntu
  IdentityFile ${KEY_PATH}
  ProxyJump master
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
EOF

chmod 600 ~/.ssh/config
echo "Jump Server configured in ~/.ssh/config"

