name        "dev"
description "development environment"

override_attributes(
  'elasticsearch' => {
    'bootstrap' => {
      'mlockall' => false
    }
  }
)
