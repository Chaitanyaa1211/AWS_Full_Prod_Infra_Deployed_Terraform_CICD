resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "db-subnet-group"
  }
}


resource "aws_db_instance" "db" {
  identifier        = "app-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "appdb"
  username = "admin"
  password = "StrongPassword123!"  # ⚠️ change later

  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  skip_final_snapshot = true
  publicly_accessible = false

  multi_az = false
}
