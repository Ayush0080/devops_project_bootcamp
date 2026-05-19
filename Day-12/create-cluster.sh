#!/bin/bash
set -e

echo "==============================="
echo "STEP-1: Create VPC using Terraform"
echo "==============================="
cd VPC_terraform-manifests
terraform init 
terraform apply -auto-approve

echo
echo "==============================="
echo "STEP-2: Create EKS Cluster using Terraform"
echo "==============================="
cd ../EKS_terraform-manifests_with_addons
terraform init 
terraform apply -auto-approve

echo
echo "✅ EKS Cluster and VPC creation completed successfully!"
