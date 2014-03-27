name        "elasticsearch"
description "elasticsearch role"

all_env = [
    "recipe[java]",
    "recipe[elasticsearch]"
]

run_list(all_env)

env_run_list(
    "_default"  => all_env,
    "prod"      => all_env,
    "dev"       => all_env
)
