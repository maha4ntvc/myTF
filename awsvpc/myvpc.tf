# variables

variable "aws_access_key" {
     default="AKIA55D7LGUS6UMT7MEU"

}
variable "aws_secret_key" {
    default="OEmN4g+0YZI6VSieMsqXB68u1fvt8F9rHRXXwQIf"
}

#aws  privider

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-2"
}


# resouces
resource "aws_vpc" "myvpc" {
  cidr_block       = "192.168.0.0/22"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "mypublicsubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "mypublicsubnet"
  }
}

resource "aws_route_table" "mypublicrouter" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
  Name = "mypublicrouter"
  }

}

resource "aws_route_table_association" "mypublicassociation" {
  subnet_id      = aws_subnet.mypublicsubnet.id
  route_table_id = aws_route_table.mypublicrouter.id
}

resource "aws_egress_only_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
  Name = "myIGW"
  }
}


resource "aws_route" "mypublicroute" {
  route_table_id              = aws_route_table.mypublicrouter.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.myIGW.id
}



# Outputs
output "myvpc_ID" {
  value = "${aws_vpc.myvpc.id}"
}

output "mypublicsubnet_ID" {
  value = "${aws_subnet.mypublicsubnet.id}"
}

output "mypublicrouter_ID" {
  value = "${aws_route_table.mypublicrouter.id}"
}

output "myIGW_ID" {
  value = "${aws_egress_only_internet_gateway.myIGW.id}"
}