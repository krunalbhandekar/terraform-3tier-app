resource "aws_db_subnet_group" "db_subnet" {
  name       = "todo-db-subnet-group"
  subnet_ids = aws_subnet.public[*].id
}

resource "aws_db_instance" "todo_db" {
  identifier             = "todo-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  db_name                = "tododb"
}
