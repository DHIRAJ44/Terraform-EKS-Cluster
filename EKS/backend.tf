terraform {
  backend "s3" {
    bucket = "dhiraj-eks-bucket"
    key    = "eks/terraform.tfstate"
    region = "us-east-2"
  }
}