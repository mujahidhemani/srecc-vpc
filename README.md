# SRE Code Challenge - Terraform VPC Module

This Terraform AWS module creates a fully functioning VPC, with public and private subnets (identified as frontend and backend), NAT Gateways, internet gateways, route tables, etc.

NOTE: 
- creates 3 frontend and 3 backend subnets (one of each per AZ)
- Only tested in us-east-1
- Only tested with /21 CIDR blocks

## Usage
```hcl
module "srecc-vpc" {
  source  = "mujahidhemani/srecc-vpc/aws"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cidrblock | The CIDR network block to use to create the VPC | string | `"10.100.0.0/21"` | no |

## Outputs

| Name | Description |
|------|-------------|
| all\_subnet\_ids | All subnet IDs \(both frontend and backend\) in a single list |
| backend\_subnet\_ids | A list of all backend subnet IDs |
| frontend\_subnet\_ids | A list of all frontend subnet IDs |
| vpc\_id | The VPC ID |

