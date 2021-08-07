
# variables

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "key_name" {
  default = "maili4devopskey123"
}

variable "instance_type" {
  default = "t2.micro"
}

# provider 

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-2"
}


# resource

resource "aws_instance" "myawsinstace" {
  ami           = "ami-083ac7c7ecf9bb9b0"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
}



# output
output "aws_instance_public_dns" {
  value = "${aws_instance.myawsinstace.public_dns}"
}