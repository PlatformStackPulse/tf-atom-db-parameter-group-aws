output "id" {
  description = "ID of the DB parameter group"
  value       = try(aws_db_parameter_group.this[0].id, null)
}

output "name" {
  description = "Name of the DB parameter group"
  value       = try(aws_db_parameter_group.this[0].name, null)
}

output "arn" {
  description = "ARN of the DB parameter group"
  value       = try(aws_db_parameter_group.this[0].arn, null)
}
