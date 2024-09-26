terraform {
  backend "s3" {
    bucket = "dhiraj-eks-bucket"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
  }
}