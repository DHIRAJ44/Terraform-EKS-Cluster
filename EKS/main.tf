data "aws_availability_zones" "azs" {}
module "myjenkins-server-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "myjenkins-server-vpc"
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myjenkins-server-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myjenkins-server-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myjenkins-server-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }
}
module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"
    cluster_name = "myjenkins-server-eks-cluster"
    cluster_version = "1.24"

    cluster_endpoint_public_access  = true

    vpc_id = module.myjenkins-server-vpc.vpc_id
    subnet_ids = module.myjenkins-server-vpc.private_subnets

    tags = {
        environment = "development"
        application = "myjenkins-server"
    }

    eks_managed_node_groups = {
        dev = {
            min_size = 1
            max_size = 3
            desired_size = 2

            instance_types = ["t2.small"]
        }
    }
}