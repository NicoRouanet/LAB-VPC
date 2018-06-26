#VPC
resource "aws_vpc" "main" {	
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	cidr_block = "${var.AWS_CIDR}"
	instance_tenancy = "default"
}

#gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

#route table
resource "aws_route_table" "route-t" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  }
  
 #Subnet public
  resource "aws_subnet" "subpublic_1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.AWS_CIDR_2}"
  map_public_ip_on_launch = "true"
   tags {
    Name = "Public Subnet"
	}
    }
	
#Subnet private
  resource "aws_subnet" "subprivee_1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.AWS_CIDR_3}"
  map_public_ip_on_launch = "false"
   tags {
    Name = "Privée Subnet"
	}
    }
	
  
  #elastic IP
  resource "aws_eip" "EIP" {
  vpc      = true
}

#NAT
	resource "aws_nat_gateway" "nat" {
	allocation_id = "${aws_eip.EIP.id}"
	subnet_id     = "${aws_subnet.subpublic_1.id}"
	depends_on = ["aws_internet_gateway.gw"]
	
}
	
#route table NAT
resource "aws_route_table" "nat_aws" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat.id}"
    }

		tags {
			Name = "RT NAT"
    }
}	
	
	
	
	
# Route associations private
resource "aws_route_table_association" "pri_associate1" {
    subnet_id = "${aws_subnet.subprivee_1.id}"
    route_table_id = "${aws_route_table.route-t.id}"
}
	
	
	
# Route associations public
resource "aws_route_table_association" "pub_associate1" {
    subnet_id = "${aws_subnet.subpublic_1.id}"
    route_table_id = "${aws_route_table.route-t.id}"
}
	
	
	
	
	
	
	
	
	
	
	
	