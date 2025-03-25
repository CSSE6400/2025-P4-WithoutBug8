
terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_files = ["./credentials"]
    default_tags {
        tags = {
            Environment = "Dev"
            Course = "CSSE6400"
            StudentID = "48993289"
        }
    }
}

resource "aws_instance" "hextris-server" {
    ami = data.aws_ami.latest.id
    instance_type = "t2.micro"
    key_name = "vockey"

    user_data = file("./serve-hextris.sh")
    security_groups = [aws_security_group.hextris-server.name]

    tags = {
        Name = "hextris"
    }
}

output "hextris-url" {
    value = aws_instance.hextris-server.public_ip
}

resource "aws_security_group" "hextris-server" {
    name = "hextris-server"
    description = "Hextris HTTP and SSH access"
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "latest" {
    most_recent = true
    owners = ["amazon"]
    # 过滤其他镜像，只寻找名字以 al2023-ami-2023 开头的镜像
    filter {
        name = "name"
        values = ["al2023-ami-2023*"]
    }
    # 只要用 EBS 卷（Amazon 的弹性块存储）的 AMI
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
    # hvm 表示硬件虚拟化
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    # 找64位镜像
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}