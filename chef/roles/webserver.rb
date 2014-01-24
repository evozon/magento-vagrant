name        "webserver"
description "webserver role"

all_env = [
    "recipe[mysql::client]",
    "recipe[mysql::server]",
    "recipe[apache2]",
    "recipe[php]",
    "recipe[php::module_curl]",
    "recipe[php::module_gd]",
    "recipe[php::module_mysql]",
    "recipe[evozon]"
]

run_list(all_env)

env_run_list(
    "_default"  => all_env,
    "prod"      => all_env,
    "dev"       => all_env + ["recipe[evozon::php_xdebug]"]
)