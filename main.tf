resource "aws_db_parameter_group" "this" {
  count = local.enabled ? 1 : 0

  name        = module.this.id
  family      = var.family
  description = coalesce(var.description, "DB parameter group for ${module.this.id}")

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "immediate")
    }
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}
