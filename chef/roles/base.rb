name        "base"
description "base role"

all_env = [
    "recipe[apt]",
    "recipe[build-essential]",
    "recipe[vim]",
    "recipe[git]",
    "recipe[evozon]"
]

run_list(all_env)

env_run_list(
    "_default"  => all_env,
    "prod"      => all_env,
    "dev"       => all_env
)