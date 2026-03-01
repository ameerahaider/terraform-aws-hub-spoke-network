# Central Networking Environment Setup

This component is the **Hub** in the multi-account AWS architecture. By following this guide, you will initialize the core Transit Gateway, IP Addresses (IPAM), and route sharing required for spoke environments (e.g., Dev and Prod) to connect safely.

## Prerequisites
- AWS CLI configured with privileges inside the Central Network (Hub) account.
- `terraform` installed locally.
- Cross-account IAM roles allowing this account to share IPAM pools and Transit Gateway resources via AWS RAM (Resource Access Manager).

## Step-by-Step Execution

### Step 1: Configure State Backend
Update `backend.tf` to point your state to your pre-configured S3 bucket and DynamoDB table. Make sure to generate dedicated resource names (e.g. `generic-company-infra-state-bucket`).

### Step 2: Configure Shared Environments
Open `terraform.tfvars` and add the AWS Account IDs for your Spoke accounts (Dev, Prod) into the `shared_account_ids` list. This enables AWS RAM to share the IPAM pools and Transit Gateway.

### Step 3: Deploy IPAM and Transit Gateway Features
1. Run `terraform init` to download required provider plugins.
2. Run `terraform plan -var-file=terraform.tfvars` to review the creation of VPCs, TGW, and IPAM resources.
3. Run `terraform apply -var-file=terraform.tfvars` and confirm.

### Step 4: Spoke Validation
Once the initial network is up, go to your spoke accounts (Dev, Prod) and accept the RAM Shared resources (IPAM pools and TGW). 

### Step 5: Finalize Routing
After deploying your Spoke networks (which will create Transit Gateway attachments), return to this folder:
1. Copy the new TGW attachment IDs and specific CIDRs assigned to the Spokes.
2. Update the `dev_attachment_ids`/`prod_attachment_ids` and corresponding `cidrs` arrays in `terraform.tfvars`.
3. Apply the changes again (`terraform apply -var-file=terraform.tfvars`) so the Hub configures return routes to the Spokes.
