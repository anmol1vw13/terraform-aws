resource "aws_security_group" "ec2_elastic_cache_group" {

    name = "Elastic Cache Group"
    vpc_id = "vpc-0adc54db253f9c7c4"
    ingress {
        description = "Ingress for the ec2"
        protocol = "tcp"
        from_port = "6379"
        to_port = "6379"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        protocol = "tcp"
        from_port = "22"
        to_port = "22"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Outbound access"
        protocol = -1
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Outbound redis access"
        protocol = "tcp"
        from_port = 6379
        to_port = 6379
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "redis_elastic_cache" {
    name = "redis-elastic-cache"
    description = "Redis Elastic Cache Group"

    ingress {
        description = "Inbound from EC2 instances"
        protocol = "tcp"
        from_port = "6379"
        to_port = "6379"
        security_groups = [aws_security_group.ec2_elastic_cache_group.id]
    }
}
