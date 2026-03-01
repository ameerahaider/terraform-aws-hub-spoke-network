# Development (Dev) Environment Configuration

This folder provisions the Spoke resources for the **Dev** environment. It utilizes shared IPAM pools and Transit Gateways established by the central `networking` account.

## Prerequisites
- The Networking (Hub) environment has been deployed.
- Ensure to accept the AWS RAM Shared Resources (Transit Gateway, Workload IPAM pool, DB IPAM pool) in the Dev AWS account console before proceeding.

## Deployment Steps

### Step 1: Initialize Backend configuration
Inside `backend.tf`, define your Dev-specific state bucket and DynamoDB lock table for secure state storage.

### Step 2: Set Variables
Open `terraform.tfvars`:
- Supply the `workload_ipam_pool_id` and `db_ipam_pool_id` parameters (obtained from the Hub IPAM outputs).
- Configure the `network_account_id`.
- Define standard tags and AZ preferences.

### Step 3: Deployment
1. Initialize the root: `terraform init`
2. Preview changes: `terraform plan -var-file=terraform.tfvars`
3. Execute the build: `terraform apply -var-file=terraform.tfvars`

### Step 4: Post-Deployment 
Pass the newly created Transit Gateway attachment IDs and related CIDR blocks back to the Network engineering team (they will inject these into the `networking` root to complete the hub routing loop).
