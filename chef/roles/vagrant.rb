name        "vagrant"
description "vagrant role"

all_env = [
    "role[base]",
    "role[webserver]",
    "role[elasticsearch]",
    "recipe[magento-ce]"
]

run_list(all_env)

env_run_list(
    "_default"  => all_env,
    "prod"      => all_env,
    "dev"       => all_env
)

override_attributes(
  'elasticsearch' => {
    'allocated_memory' => '512m',
    'bootstrap' => {
      'mlockall' => false
    }
  }
)
