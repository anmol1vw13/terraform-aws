resource "aws_instance" "ec2_elastic_cache" {
  instance_type = "t2.micro"
  ami                  = "ami-06791f9213cbb608b"
  key_name             = "terraform-key"
  security_groups      = [aws_security_group.ec2_elastic_cache_group.name]
}


output "ip" {
    value = {
        "ec2": aws_instance.ec2_elastic_cache.public_dns
        "cluster_address": aws_elasticache_cluster.redis.cache_nodes[0].address
        "connect-via-localhost": "ssh -i terraform-key.pem -f -L 6379:${aws_elasticache_cluster.redis.cache_nodes[0].address}:6379 -N ec2-user@${aws_instance.ec2_elastic_cache.public_dns}"
    }
}