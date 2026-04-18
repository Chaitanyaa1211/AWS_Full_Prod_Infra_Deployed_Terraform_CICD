#!/bin/bash

echo "Initializing Terraform..."
terraform init

echo "Planning..."
terraform plan

echo "Applying..."
terraform apply -auto-approve
