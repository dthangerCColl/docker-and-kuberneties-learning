# Terraform Commands Reference

## Terraform Workflow Overview

Terraform is an Infrastructure as Code (IaC) tool that enables you to define and provision infrastructure using a declarative configuration language. The typical Terraform workflow follows these stages:

1. **Write**: Create `.tf` configuration files defining your infrastructure resources
2. **Initialize**: Download provider plugins and initialize the working directory
3. **Plan**: Preview changes that Terraform will make to your infrastructure
4. **Validate**: Check configuration syntax and internal consistency
5. **Apply**: Create, update, or delete infrastructure resources
6. **Manage**: Use state management to track resource changes
7. **Destroy**: Remove infrastructure when no longer needed

### Terraform with VS Code

VS Code offers excellent Terraform support through extensions like HashiCorp Terraform and Terraform Advanced Syntax Highlighting. These provide syntax highlighting, IntelliSense, validation, and formatting. Terraform Cloud integration allows for remote state management and collaborative workflows.

---

## 15 Most Used Terraform Commands

### 1. `terraform init`

**Initialize a Terraform working directory**

```bash
terraform init                      # Initialize current directory
terraform init -upgrade             # Upgrade provider plugins to latest versions
terraform init -migrate-state       # Migrate state from one backend to another
terraform init -reconfigure         # Reconfigure backend, ignoring saved config
terraform init -backend=false       # Skip backend initialization
terraform init -get=false           # Skip module download
```

### 2. `terraform plan`

**Preview changes before applying**

```bash
terraform plan                      # Show execution plan
terraform plan -out=tfplan          # Save plan to file
terraform plan -var="region=us-west-2"  # Set variable value
terraform plan -var-file="prod.tfvars"  # Use variable file
terraform plan -target=aws_instance.web  # Plan specific resource
terraform plan -refresh=false       # Skip state refresh
terraform plan -destroy             # Plan destruction of resources
```

### 3. `terraform apply`

**Create or update infrastructure**

```bash
terraform apply                     # Apply changes (prompts for confirmation)
terraform apply -auto-approve       # Apply without confirmation prompt
terraform apply tfplan              # Apply saved plan file
terraform apply -var="region=us-west-2"  # Set variable value
terraform apply -var-file="prod.tfvars"  # Use variable file
terraform apply -target=aws_instance.web  # Apply specific resource
terraform apply -parallelism=10     # Set number of concurrent operations
```

### 4. `terraform destroy`

**Destroy Terraform-managed infrastructure**

```bash
terraform destroy                   # Destroy all resources (prompts for confirmation)
terraform destroy -auto-approve     # Destroy without confirmation
terraform destroy -target=aws_instance.web  # Destroy specific resource
terraform destroy -var-file="prod.tfvars"   # Use variable file
```

### 5. `terraform validate`

**Validate configuration syntax**

```bash
terraform validate                  # Validate configuration files
terraform validate -json            # Output validation results as JSON
terraform validate -no-color        # Disable color output
```

### 6. `terraform fmt`

**Format configuration files**

```bash
terraform fmt                       # Format files in current directory
terraform fmt -recursive            # Format files in subdirectories
terraform fmt -check                # Check if files are formatted (exit 0 if yes)
terraform fmt -diff                 # Show formatting differences
terraform fmt file.tf               # Format specific file
```

### 7. `terraform state`

**Manage Terraform state**

```bash
terraform state list                # List resources in state
terraform state show aws_instance.web  # Show details of specific resource
terraform state mv aws_instance.web aws_instance.app  # Rename resource
terraform state rm aws_instance.web  # Remove resource from state
terraform state pull                # Pull current state and output to stdout
terraform state push                # Manually upload local state file
terraform state replace-provider    # Replace provider in state
```

### 8. `terraform output`

**Read output values from state**

```bash
terraform output                    # Show all outputs
terraform output instance_ip        # Show specific output value
terraform output -json              # Output in JSON format
terraform output -raw instance_ip   # Output raw value (no quotes)
```

### 9. `terraform import`

**Import existing infrastructure into Terraform**

```bash
terraform import aws_instance.web i-1234567890abcdef0  # Import AWS EC2 instance
terraform import aws_s3_bucket.bucket my-bucket-name   # Import S3 bucket
terraform import -var-file="prod.tfvars" resource.name id  # Import with variables
```

### 10. `terraform workspace`

**Manage workspaces for multiple environments**

```bash
terraform workspace list            # List all workspaces
terraform workspace show            # Show current workspace
terraform workspace new dev         # Create new workspace
terraform workspace select dev      # Switch to workspace
terraform workspace delete dev      # Delete workspace
```

### 11. `terraform refresh`

**Update state to match real-world infrastructure**

```bash
terraform refresh                   # Update state file
terraform refresh -var-file="prod.tfvars"  # Use variable file
terraform refresh -target=aws_instance.web  # Refresh specific resource
```

### 12. `terraform taint`

**Mark a resource for recreation**

```bash
terraform taint aws_instance.web    # Mark resource as tainted
terraform taint -allow-missing aws_instance.web  # Succeed even if resource doesn't exist
terraform taint module.vpc.aws_subnet.private  # Taint resource in module
```

### 13. `terraform untaint`

**Remove taint from a resource**

```bash
terraform untaint aws_instance.web  # Remove taint from resource
terraform untaint module.vpc.aws_subnet.private  # Untaint resource in module
```

### 14. `terraform graph`

**Generate visual representation of configuration**

```bash
terraform graph                     # Output graph in DOT format
terraform graph | dot -Tpng > graph.png  # Generate PNG image
terraform graph -type=plan          # Graph of plan
terraform graph -type=apply         # Graph of apply operations
```

### 15. `terraform show`

**Show current state or saved plan**

```bash
terraform show                      # Show current state
terraform show tfplan               # Show saved plan file
terraform show -json                # Output in JSON format
terraform show -json | jq           # Pretty-print JSON with jq
```

---

## Additional Useful Commands

### Configuration Management

```bash
terraform get                       # Download and update modules
terraform get -update               # Update modules to latest versions
terraform providers                 # Show provider requirements
terraform providers schema -json    # Output provider schemas as JSON
terraform version                   # Show Terraform version
```

### Advanced State Operations

```bash
terraform state list | grep aws_instance  # Filter state resources
terraform state show -json aws_instance.web  # Show resource in JSON
terraform force-unlock LOCK_ID      # Manually unlock state
terraform refresh -lock=false       # Refresh without state lock
```

### Testing & Debugging

```bash
TF_LOG=DEBUG terraform apply        # Enable debug logging
TF_LOG=TRACE terraform plan         # Enable trace logging
TF_LOG_PATH=./terraform.log terraform apply  # Log to file
terraform console                   # Interactive console for expressions
terraform test                      # Run tests (Terraform 1.6+)
```

### Output & Formatting

```bash
terraform show -no-color            # Disable color output
terraform plan -no-color > plan.txt # Save plan to file
terraform output -json > outputs.json  # Export outputs to JSON
```

---

## Terraform Configuration File Structure

### Basic main.tf Example

```hcl
# Provider configuration
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Data sources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Resources
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.public.id

  tags = {
    Name = "${var.project_name}-web-server"
  }

  user_data = file("${path.module}/scripts/init.sh")

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Outputs
output "instance_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}
```

### variables.tf

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access resources"
  type        = list(string)
  default     = []
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
```

### terraform.tfvars

```hcl
aws_region      = "us-west-2"
environment     = "production"
instance_type   = "t3.medium"
project_name    = "myapp"
enable_monitoring = true

allowed_cidr_blocks = [
  "10.0.0.0/8",
  "172.16.0.0/12"
]

tags = {
  Team       = "DevOps"
  CostCenter = "Engineering"
}
```

### outputs.tf

```hcl
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "web_server_url" {
  description = "URL of the web server"
  value       = "http://${aws_instance.web.public_ip}"
}

output "connection_string" {
  description = "Database connection string"
  value       = "postgresql://${aws_db_instance.main.endpoint}"
  sensitive   = true
}
```

### Backend Configuration (backend.tf)

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

# Alternative: Remote backend (Terraform Cloud)
# terraform {
#   cloud {
#     organization = "my-org"
#     workspaces {
#       name = "my-workspace"
#     }
#   }
# }

# Alternative: Azure backend
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "terraform-state"
#     storage_account_name = "tfstate12345"
#     container_name       = "tfstate"
#     key                  = "prod.terraform.tfstate"
#   }
# }
```

---

## Terraform Development Tools

### VS Code Extensions

- **HashiCorp Terraform**: Official extension with syntax highlighting, IntelliSense, and formatting
- **Terraform Advanced Syntax Highlighting**: Enhanced syntax highlighting
- **Terraform Autocomplete**: Auto-completion for Terraform resources
- **Azure Terraform**: Azure-specific Terraform support

### Terraform Cloud

- Remote state management with encryption
- Collaborative workflow with team access controls
- Policy as Code with Sentinel
- Cost estimation before apply
- Private module registry
- VCS integration (GitHub, GitLab, Bitbucket)

### CLI Tools

```bash
# TFLint - Terraform linter
brew install tflint
tflint --init
tflint

# Terragrunt - DRY Terraform configurations
brew install terragrunt
terragrunt plan
terragrunt apply

# Terrascan - Security scanner
brew install terrascan
terrascan scan

# Checkov - Infrastructure security scanner
pip install checkov
checkov -d .

# Terraform-docs - Generate documentation
brew install terraform-docs
terraform-docs markdown table . > README.md
```

---

## Best Practices

1. **Version control**: Always commit `.tf` files to git, never commit `.tfstate` or `terraform.tfvars` with secrets
2. **Remote state**: Use remote state backends (S3, Azure Storage, Terraform Cloud) for team collaboration
3. **State locking**: Enable state locking with DynamoDB (AWS) or equivalent to prevent conflicts
4. **Workspaces**: Use workspaces for managing multiple environments (dev, staging, prod)
5. **Modules**: Create reusable modules for common infrastructure patterns
6. **Variables**: Use variables for all configurable values, never hardcode
7. **Validation**: Run `terraform validate` and `terraform plan` before every apply
8. **Sensitive data**: Mark sensitive outputs and use secret management tools (Vault, AWS Secrets Manager)
9. **Resource naming**: Use consistent naming conventions with environment prefixes
10. **Documentation**: Document all variables, outputs, and complex logic

### Module Structure

```
modules/
  vpc/
    main.tf
    variables.tf
    outputs.tf
    README.md
  ec2/
    main.tf
    variables.tf
    outputs.tf
    README.md
```

### Using Modules

```hcl
module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  environment = var.environment

  tags = var.common_tags
}

module "web_servers" {
  source = "./modules/ec2"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids

  instance_count = 3
  instance_type  = "t3.medium"
}

# Using remote module
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.0"

  bucket = "my-app-bucket"
  acl    = "private"

  versioning = {
    enabled = true
  }
}
```

### Locals for DRY Code

```hcl
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }

  name_prefix = "${var.project_name}-${var.environment}"

  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-web-server"
    }
  )
}
```

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Initialize directory | `terraform init` |
| Upgrade providers | `terraform init -upgrade` |
| Validate config | `terraform validate` |
| Format files | `terraform fmt -recursive` |
| Preview changes | `terraform plan` |
| Apply changes | `terraform apply` |
| Apply without prompt | `terraform apply -auto-approve` |
| Destroy infrastructure | `terraform destroy` |
| List state resources | `terraform state list` |
| Show resource | `terraform state show resource.name` |
| Show outputs | `terraform output` |
| Import resource | `terraform import resource.name id` |
| List workspaces | `terraform workspace list` |
| Switch workspace | `terraform workspace select dev` |
| Mark for recreation | `terraform taint resource.name` |

---

## Troubleshooting Common Issues

### State Lock Issues

```bash
# If state is locked and previous operation failed
terraform force-unlock LOCK_ID

# Check current state lock
terraform state list

# Disable locking (use with caution)
terraform apply -lock=false
```

### Provider Issues

```bash
# Provider plugin not found
terraform init -upgrade

# Clear provider cache
rm -rf .terraform
terraform init

# Use specific provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.0.0"  # Exact version
    }
  }
}
```

### State File Issues

```bash
# State file corrupted
terraform state pull > backup.tfstate
# Edit state carefully or restore from backup

# State out of sync
terraform refresh

# Remove resource from state (without destroying)
terraform state rm aws_instance.old_server

# Move resource to different state file
terraform state mv -state-out=other.tfstate aws_instance.web aws_instance.web
```

### Resource Conflicts

```bash
# Resource already exists in cloud but not in state
terraform import aws_instance.web i-1234567890abcdef0

# Force replacement of resource
terraform apply -replace=aws_instance.web

# Target specific resource
terraform apply -target=aws_instance.web
terraform destroy -target=aws_instance.web
```

### Debugging

```bash
# Enable detailed logging
export TF_LOG=DEBUG
terraform apply

# Enable trace logging (most verbose)
export TF_LOG=TRACE
terraform plan

# Log to file
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform-debug.log
terraform apply

# Disable logging
unset TF_LOG
unset TF_LOG_PATH
```

---

## Working with Multiple Environments

### Using Workspaces

```bash
# Create workspaces for each environment
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch to environment
terraform workspace select dev
terraform plan
terraform apply

# Reference workspace in config
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"

  tags = {
    Environment = terraform.workspace
  }
}
```

### Using Variable Files

```bash
# environments/dev.tfvars
environment = "development"
instance_type = "t3.micro"
instance_count = 1

# environments/prod.tfvars
environment = "production"
instance_type = "t3.large"
instance_count = 5

# Apply with specific environment
terraform apply -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/prod.tfvars"
```

### Using Directory Structure

```
environments/
  dev/
    main.tf
    variables.tf
    terraform.tfvars
  staging/
    main.tf
    variables.tf
    terraform.tfvars
  prod/
    main.tf
    variables.tf
    terraform.tfvars

# Deploy to specific environment
cd environments/dev
terraform init
terraform apply
```

---

## Advanced Terraform Patterns

### Conditional Resources

```hcl
resource "aws_instance" "web" {
  count = var.create_instance ? 1 : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
}

resource "aws_cloudwatch_alarm" "cpu" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  threshold           = "80"
}
```

### Dynamic Blocks

```hcl
resource "aws_security_group" "web" {
  name   = "web-sg"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

### For Expressions

```hcl
locals {
  # Create map from list
  instance_ips = {
    for instance in aws_instance.web :
    instance.id => instance.private_ip
  }

  # Filter and transform
  prod_instances = [
    for instance in aws_instance.all :
    instance.id if instance.tags["Environment"] == "production"
  ]
}
```

### Data Source Dependencies

```hcl
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

resource "aws_instance" "app" {
  subnet_id = data.aws_subnets.private.ids[0]
  # ...
}
```

---

## State Management Best Practices

### Remote State with S3

```hcl
# Configure backend
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"

    # Optional: versioning enabled on bucket
  }
}

# Create S3 bucket for state (run once)
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for locks (run once)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### Using Remote State Data

```hcl
# Read outputs from another state file
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "my-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "app" {
  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet_id
  # ...
}
```

---

## Testing Terraform Code

### Using Terraform Console

```bash
# Test expressions interactively
terraform console

> var.environment
"production"

> local.name_prefix
"myapp-production"

> aws_instance.web[0].public_ip
"54.123.45.67"
```

### Validation Tests

```hcl
# variables.tf
variable "instance_type" {
  type = string

  validation {
    condition     = can(regex("^t3\\.", var.instance_type))
    error_message = "Instance type must be a t3 instance."
  }
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### Pre-commit Hooks

```bash
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
      - id: terraform_docs

# Install
brew install pre-commit
pre-commit install
```

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Terraform

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.6.0

    - name: Terraform Format
      run: terraform fmt -check

    - name: Terraform Init
      run: terraform init

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

---

## Common Provider Examples

### AWS

```hcl
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
```

### Azure

```hcl
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}
```

### Google Cloud

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
```

### Kubernetes

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```
