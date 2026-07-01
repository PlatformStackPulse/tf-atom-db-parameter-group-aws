# Unit Tests — tf-atom-db-parameter-group-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: assertions target plan-KNOWN values only (the tf-label id string,
# resource count, and input pass-throughs). Computed attributes like the
# real arn/id/name are unknown under a mock provider and must not be asserted.

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-required input
  family = "postgres16"

  # sample parameters
  parameters = [
    {
      name         = "max_connections"
      value        = "200"
      apply_method = "pending-reboot"
    },
    {
      name  = "log_min_duration_statement"
      value = "500"
    }
  ]
}

# ---------------------------------------------------------------------------
# Test: module creates the parameter group when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = length(aws_db_parameter_group.this) == 1
    error_message = "Expected exactly one aws_db_parameter_group when enabled."
  }

  assert {
    condition     = aws_db_parameter_group.this[0].name == "eg-test-thing"
    error_message = "Parameter group name must equal the tf-label id 'eg-test-thing'."
  }

  assert {
    condition     = aws_db_parameter_group.this[0].family == "postgres16"
    error_message = "family input must be passed through to the parameter group."
  }

  assert {
    condition     = length(aws_db_parameter_group.this[0].parameter) == 2
    error_message = "Both supplied parameters must be rendered on the parameter group."
  }
}

# ---------------------------------------------------------------------------
# Test: description defaults to a derived value when not supplied
# ---------------------------------------------------------------------------
run "default_description_is_derived" {
  command = plan

  assert {
    condition     = aws_db_parameter_group.this[0].description == "DB parameter group for eg-test-thing"
    error_message = "description must default to 'DB parameter group for <id>' when unset."
  }
}

# ---------------------------------------------------------------------------
# Test: disabled module creates nothing and outputs are null
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_db_parameter_group.this) == 0
    error_message = "No parameter group should be created when enabled = false."
  }

  assert {
    condition     = output.arn == null
    error_message = "arn output must be null when the module is disabled."
  }

  assert {
    condition     = output.id == null
    error_message = "id output must be null when the module is disabled."
  }
}
