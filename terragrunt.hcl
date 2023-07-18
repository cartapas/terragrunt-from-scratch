terraform {
  extra_arguments "persist_plan" {
    commands = [
      "plan"
    ]

    arguments = [
      "-out", "terraform.tfplan"
    ]
  }
  extra_arguments "apply_persisted_plan" {
    commands = [
      "apply"
    ]

    arguments = [
      "terraform.tfplan"
    ]
  }
}
