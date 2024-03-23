resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}