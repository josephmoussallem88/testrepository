variable "availability_zone" {
type= string
default = "eu-west-3a"
}

variable "subnet1-tag" {
type= string
default = "production-Subnet"

}


# providers.tf
provider "aws" {
  region = "eu-west-3"
}

# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instances"
  default     = "ami-0047c43abbad5198e"  # Change to your desired AMI
}

variable "key_name" {
  description = "EC2 Key Pair"
  default     = "main-key"
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling group"
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling group"
  default     = 3
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling group"
  default     = 1
}

variable "vpc_subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = "subnet-01e4b406b89ef773e" # Replace with your subnet IDs
}

