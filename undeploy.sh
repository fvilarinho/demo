#!/bin/bash

cd iac

# Define the terraform client used to provision the infrastructure.
export TERRAFORM_CMD=`which terraform`

if [ -z "$TERRAFORM_CMD" ]; then
  TERRAFORM_CMD=./terraform
fi

# Check if the terraform settings environment is created.
if [ ! -d "~/.terraform.d" ]; then
  mkdir -p ~/.terraform.d
fi

# Check if the terraform authentication settings is created.
if [ ! -f "~/.terraform.d/credentials.tfrc.json" ]; then
  # Create the credentials files.
  cp credentials.tfrc.json /tmp

  sed -i -e 's|${TERRAFORM_TOKEN}|'"$TERRAFORM_TOKEN"'|g' /tmp/credentials.tfrc.json

  mv /tmp/credentials.tfrc.json ~/.terraform.d
fi

# Execute the provisioning based on the IaC definition file (terraform.tf).
$TERRAFORM_CMD init --upgrade
$TERRAFORM_CMD destroy -auto-approve \
                       -var "linode_token=$LINODE_TOKEN" \
                       -var "linode_ssh_key=$LINODE_SSH_KEY" \
                       -var "k3s_token=$K3S_TOKEN" \
                       -var "datadog_agent_key=$DATADOG_AGENT_KEY"

cd ..
