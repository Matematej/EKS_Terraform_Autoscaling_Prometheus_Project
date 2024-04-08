resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}
 # Private Subnets for EKS
resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-east-1a"
 # Tags "kubernetes" to set up ELB
  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev",
    Name                            = "private-us-east-1a",
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/MyCluster"      = "owned"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1b"
 # Tags "kubernetes" to set up ELB
  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev",
    Name                            = "private-us-east-1b",
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/MyCluster"      = "owned"
  }
}

 # Public Subnets for ELB
resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
 # Tags "kubernetes" to set up ELB
  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev",
    Name                       = "public-us-east-1a",
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/MyCluster" = "owned"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
 # Tags "kubernetes" to set up ELB
  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev",
    Name                       = "public-us-east-1b",
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/MyCluster" = "owned"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Project     = "EKS_Terraform_Project",
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "private-us-east-1a" {
  subnet_id      = aws_subnet.private-us-east-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id      = aws_subnet.private-us-east-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.public.id
}



