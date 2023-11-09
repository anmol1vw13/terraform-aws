resource "aws_db_instance" "db-3" {
    instance_class = "db.t3.micro"
    identifier = "db-3"
    engine = "postgres"
    engine_version = "15.3"
    multi_az = true
    backup_retention_period     = 7

    db_name = "database2"
    username = "postgres"
    password = "postgres"
    storage_type = "io1"
    allocated_storage = 100
    iops = 3000
    publicly_accessible = true
    skip_final_snapshot = true
    vpc_security_group_ids = [aws_security_group.db-sec.id]
    port = 5432
}


resource "aws_db_instance" "db-3-replica" {
    replicate_source_db = aws_db_instance.db-3.identifier
    instance_class = "db.t3.micro"
    identifier = "db-3-replica"
    engine = "postgres"
    engine_version = "15.3"
    multi_az = false
    storage_type = "io1"
    backup_retention_period     = 7
    iops = 3000
    publicly_accessible = true
    skip_final_snapshot = true
    vpc_security_group_ids = [aws_security_group.db-sec.id]
    port = 5432
}



resource "aws_security_group" "db-sec" {
  name = "db2-sec"
  description = "Security Group for DB"
  ingress {
    description = "Connections to DB"
    protocol = "tcp"
    from_port = 5432
    to_port = 5432
    cidr_blocks = [
        "0.0.0.0/0"
    ]
  }

  egress {
    description = "Connections from DB"
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "postgres_dns" {
    value = [{"main": aws_db_instance.db-3.endpoint, "replica": aws_db_instance.db-3-replica.endpoint} ]
}