# Wheel
This project deploys nginx to AWS ECS using Fargate. All deployments are done using terraform. Below you will find steps on how to run this project.
The terraform module also create a VPC for this deployment referencing the aws vpc module.
## Folder Structure
```
├── README.md
└── terraform
    ├── cluster.tf
    ├── iam.tf
    ├── lb.tf
    ├── outputs.tf
    ├── provider.tf
    ├── security_groups.tf
    └── vpc.tf

```

## Requirements
- Terraform 
- AWS free tier account

## How to Run Application
### Step 1
- `git clone https://github.com/lseino/wheel`
- `cd wheel`

### Step 2 - Run Terraform Code
- `cd terraform`
- `terraform init && terraform plan`
- `terraform apply`
- After completion, the terraform code will output the load balancer DNS name. Copy it and paste on your web browser eg `nginx-lb-tf-1584404261.us-east-1.elb.amazonaws.com` to see results

## Clean Up
- `terraform destroy`