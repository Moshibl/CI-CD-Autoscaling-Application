#!/bin/bash

ScriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WorkDir="$(dirname "$ScriptDir")"

InventoryFile="$WorkDir/Ansible/inventory"

rm -f "$InventoryFile"

{
  echo "[Master]"
  echo master

  echo "[Slave]"
  echo slave

  echo "[Backend]"
  aws ec2 describe-instances \
    --filters "Name=tag:Role,Values=Backend" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --output text
} >> "$InventoryFile"

