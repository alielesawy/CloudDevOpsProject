# Terraform AWS Infrastructure Project

This project provisions AWS infrastructure including VPC, subnet, security groups, and EC2 instances using Terraform with an S3 backend for state management.
![](/assets/icons8-terraform-144.png) ![](/assets/icons8-aws-144.png)

![](/assets/s3.svg) ![](/assets/vpc.svg) ![](/assets/ec2.svg)
## Task 4: Infrastructure Provisioning

### Setting Up Environment

1. **AWS Credentials**
   - Configure AWS credentials either via:
     - AWS CLI: `aws configure`
     - Environment variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
     - IAM role (if running on AWS infrastructure)

2. **Create S3 Bucket**
   - Create an S3 bucket for Terraform state storage
   - Example bucket name: `terraform-state-bucket`
   - Note: This project uses S3 for state management without DynamoDB for locking
   - Update the bucket name in `main.tf` backend configuration if different

3. **Project Structure**
 - [main.tf](/Task4/main.tf)
 - [modules/](/Task4/modules/)
    - [vpc/](/Task4/modules/vpc)
        - [main.tf](/Task4/modules/vpc/main.tf) 
        - [variables.tf](/Task4/modules/vpc/variables.tf)
        - [outputs.tf](/Task4/modules/vpc/outputs.tf)
    - [ec2/](/Task4/modules/ec2)
        - [main.tf](/Task4/modules/ec2/main.tf)
        - [variables.tf](/Task4/modules/ec2/variables.tf)
### Running Terraform

1. Initialize Terraform:
```bash
terraform init
```

2. Create an execution plan:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

### Demos

- **Plan**: Review the planned changes before applying
![](/assets/task4-plan.png)
- **Apply**: Deploy the infrastructure to AWS
![](/assets/task4-apply.png)
- **EC2**: Check AWS Console for 2 running EC2 instances
![](/assets/task4-ec2.png)
- **CloudWatch**: Verify CPU utilization alarms in CloudWatch
![](/assets/task4-cloudwatch.png)
- **S3 Remote statefile**: only s3 bucket without DynamoDB
![](/assets/task4-remotestate.png)

### Plan Output
- The `terraform plan` output is saved as [`plan.txt`](/Task4/plan.txt) for reference
- To generate: `terraform plan > plan.txt`

### Notes
- Ensure the AMI ID in `modules/ec2/main.tf` matches your region
- Security groups allow HTTP (80) and SSH (22) access
- State is stored in S3 without locking (no DynamoDB)
- Adjust variables in module files as needed for your use case
