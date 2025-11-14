# Create a VPC with private subnets for the runner if no subnets are provided
# It includes a public routing subnet with internet access for pulling the runner image

data "aws_availability_zones" "available" {}

module "vpc" {
  count = local.create_vpc ? 1 : 0

  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "${random_id.suffix.hex}-runner"
  cidr                   = "10.0.0.0/16"
  region                 = var.region
  azs                    = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets         = ["10.0.0.0/24"]
  private_subnets        = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  default_security_group_egress = [
    {
      cidr_blocks = "0.0.0.0/0"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
    },
  ]
}
