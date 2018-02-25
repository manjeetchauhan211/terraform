#aws.tf file new
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "aws_region" {}
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}
resource "aws_key_pair" "new-key1" {
  key_name = "new-404"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDm9BGj0exTWGm5MHihLP2qXh6jufo+Yt0KXKjZEzf+rKH4yRkVvLU+4RAAW8nuRR+Lb4GilJrwEjvqXs2HgGv+yAgIj/qj//BI/OQbPG5nzlpDX/o9x2jCC3MJFYKSRjH/eAWKkq2/d5LsWan+0wuIaQC6BLoUFEwDcVdCnDbd+RwaxnI4ADMhEZwXo3IJx1o4PwQF51+ZVo1kyZL32qVy7CCRBZ0TKOQoibM4vSCJA8JDuYpQvdEauDPuLtYba+lIk4oZH7pDSUwboZPs2nGKQ9GY7ccGqeF+1s8Ve1li20A12MF7WW5T373FiBy0PDDOJ4kRvsXboRYcDs2rVtsV root@ip-172-31-47-90" 
}

resource "aws_instance" "web" {
   count = 1
   ami = "ami-ae7bfdb8"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.new-key1.key_name}"
   tags {
      Name = "Test-VM"
    }
provisioner "local-exec" {
   command = "echo ${aws_instance.web.public_ip} > /tmp/ip_address.txt"
  }
provisioner "local-exec" {
   #command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key=/home/jenkins/newkey.pem -i '${aws_instance.web.public_ip},' master.yml"
   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u centos --private-key=/home/jenkins/newkey.pem -i /tmp/ip_address.txt master.yml --become-user=root"
}
} 
