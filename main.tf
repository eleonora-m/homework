provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "penguin_server" {
  ami           = "ami-0c7217cdde317cfec" # ID для Ubuntu 22.04 в us-east-1
  instance_type = "t2.micro"
  key_name      = "mac-new-2026" # Имя твоего ключа, который ты создала в AWS

  # Настройка сети, чтобы порт 80 был открыт
  vpc_security_group_ids = [aws_security_group.caddy_sg.id]

  tags = {
    Name = "Caddy-Penguin-Server"
  }
}

resource "aws_security_group" "caddy_sg" {
  name = "allow_web"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Доступ по SSH
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Доступ для сайта
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}