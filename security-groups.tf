/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  provider    = aws.region-master-yalk
  name        = "master-vpc-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.master.id
  depends_on  = [aws_vpc.master]
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Master-SG-Default"
  }
}