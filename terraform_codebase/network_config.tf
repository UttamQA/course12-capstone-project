#aws vpc config
resource "aws_vpc" "capstone-project-vpc"{
        cidr_block = "10.0.0.0/16"
        enable_dns_hostnames = true
        tags = {
                Name = "capstone-project-vpc"
        }
}

#public subnet1 config
resource "aws_subnet" "public-subnet1"{
        vpc_id = aws_vpc.capstone-project-vpc.id
        cidr_block = "10.0.1.0/24"
        availability_zone = "us-east-1a"
        tags = {
                Name = "Public Subnet-1"
        }
}

#public subnet2 config
resource "aws_subnet" "public-subnet2"{
        vpc_id = aws_vpc.capstone-project-vpc.id
        cidr_block = "10.0.2.0/24"
        availability_zone = "us-east-1b"
        tags = {
                Name = "Public Subnet-2"
        }
}

#private subnet1 config
resource "aws_subnet" "private-subnet1"{
        vpc_id = aws_vpc.capstone-project-vpc.id
        cidr_block = "10.0.101.0/24"
        availability_zone = "us-east-1a"
        tags = {
                Name = "Private Subnet-1"
        }
}

#private subnet2 config
resource "aws_subnet" "private-subnet2"{
        vpc_id = aws_vpc.capstone-project-vpc.id
        cidr_block = "10.0.102.0/24"
        availability_zone = "us-east-1b"
        tags = {
                Name = "Private Subnet-2"
        }
}

#aws internet gateway config
resource "aws_internet_gateway" "IGW"{
        vpc_id = aws_vpc.capstone-project-vpc.id
        tags = {
                Name = "Internet Gateway"
        }
}

#aws eip config
resource "aws_eip" "eip"{
        vpc = true
}

#aws nat gateway config
resource "aws_nat_gateway" "NGW"{
        allocation_id = aws_eip.eip.id
        subnet_id = aws_subnet.public-subnet1.id
        tags = {
                Name = "NAT Gateway"
        }
}

#creating route table for public subnet
resource "aws_route_table" "public_subnet_rt"{
        vpc_id = aws_vpc.capstone-project-vpc.id
        route{
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.IGW.id
        }

        tags = {
                Name = "Public Subnet Route Table"
        }
}

#public subnet attachment to route table
resource "aws_route_table_association" "public_subnet1_rt_association"{
        subnet_id = aws_subnet.public-subnet1.id
        route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public_subnet2_rt_association"{
        subnet_id = aws_subnet.public-subnet2.id
        route_table_id = aws_route_table.public_subnet_rt.id
}

#creating route table for NAT gateway
resource "aws_route_table" "ngw_rt"{
        vpc_id = aws_vpc.capstone-project-vpc.id
        route{
                cidr_block = "0.0.0.0/0"
                nat_gateway_id = aws_nat_gateway.NGW.id
        }

        tags = {
                Name = "NAT Gateway Route Table"
        }
}

#attaching the private subnets to NAT gateway route table
resource "aws_route_table_association" "private_subnet1_rt_association"{
        subnet_id = aws_subnet.private-subnet1.id
        route_table_id = aws_route_table.ngw_rt.id
}

resource "aws_route_table_association" "private_subnet2_rt_association"{
        subnet_id = aws_subnet.private-subnet2.id
        route_table_id = aws_route_table.ngw_rt.id
}
