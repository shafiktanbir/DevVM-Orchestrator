resource "aws_instance" "web" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t2.nano"
  key_name               = "instance-key"
  vpc_security_group_ids = [aws_security_group.dove-sg.id]
  availability_zone      = "ap-south-1a"

  tags = {
    Name    = "Dove-web"
    Project = "Dove"
  }
}

resource "aws_ec2_instance_state" "web-state" {
  instance_id = aws_instance.web.id
  state       = "running"
}