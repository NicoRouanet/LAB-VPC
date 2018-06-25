resource "aws_instance" "exemple" {	
	ami		= "ami-14c5486b"
	instance_type = "t2.micro"
}