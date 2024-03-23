resource "aws_eip" "nat" {

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}
