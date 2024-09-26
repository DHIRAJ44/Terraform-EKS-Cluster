terraform {
  backend "s3" {
     bucket = "dhiraj-eks-bucket"
     key="jenkins/terraform.tfstate"
     region="us-east-1" 
  }
}