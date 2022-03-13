#Get Linux AMI ID using SSM Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master-yalk
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master-yalk
  key_name   = "jenkins"
  public_key = file("~/.ssh/jenkins.pub")
}

data "aws_ami" "ubuntu" {
  provider    = aws.region-master-yalk
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance-type
  key_name               = aws_key_pair.master-key.key_name
  subnet_id              = aws_subnet.master_public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.default.id]
  tags = {
    Name = "web"
  }
}


resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance-type
  key_name               = aws_key_pair.master-key.key_name
  subnet_id              = aws_subnet.master_private_subnets[0].id
  vpc_security_group_ids = [aws_security_group.default.id]
  tags = {
    Name = "db"
  }
}