# Production (Prod) Environment Configuration

This folder provisions the Spoke resources for the **Prod** environment. Similar to Dev, this stack establishes dedicated DB and Workload VPCs utilizing shared IP Address Management (IPAM) tools.

## Prerequisites
- The Networking (Hub) environment has been deployed.
- Open the AWS Prod Console. Ensure AWS RAM Shared Resources (Transit Gateway, Prod Workload IPAM, Prod DB IPAM) have been accepted.

## Deployment Steps

### Step 1: Initialize Backend configuration
The repository's `backend.tf` should define the Prod-specific state S3 bucket and DynamoDB table. Be sure cross-account roles natively authorize state read/writes for appropriate Devops users safely connecting into Prod.

### Step 2: Set Variables
Open `terraform.tfvars`:
- Map the `workload_ipam_pool_id` and `db_ipam_pool_id` values to those provisioned during the `networking` step.
- Update `network_account_id` accordingly.
- Set standard Prod tags, ensuring high standards for billing mapping and reporting.

### Step 3: Deployment
1. Initialize the backend and providers: `terraform init`
2. Preview changes: `terraform plan -var-file=terraform.tfvars`
3. Execute the build carefully: `terraform apply -var-file=terraform.tfvars`

### Step 4: Post-Deployment 
Return the generated TGW Attachment ID and assigned Prod CIDRs to the Networking engineer team to integrate via the `networking` root stack, finalizing transit routing rules into production workloads.
