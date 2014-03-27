name        "webserver"
description "webserver role"

all_env = [
    "recipe[mysql::client]",
    "recipe[mysql::server]",
    "recipe[apache2]",
    "recipe[apache2::mod_php5]",
    "recipe[apache2::mod_headers]",
    "recipe[apache2::mod_rewrite]",
    "recipe[apache2::mod_expires]",
    "recipe[apache2::mod_deflate]",
    "recipe[php]",
    "recipe[php::module_curl]",
    "recipe[php::module_gd]",
    "recipe[php::module_mysql]",
    "recipe[php::module_apc]"
]

run_list(all_env)

env_run_list(
    "_default"  => all_env,
    "prod"      => all_env,
    "dev"       => all_env + ["recipe[evozon::php_xdebug]"]
)

override_attributes(
    'php' => {
        'directives' => {
            'memory_limit' => '64M',
            'max_execution_time' => '18000',
            'magic_quotes_gpc' => 'off',
            'session.auto_start' => 'off',
            'zlib.output_compression' => 'on',
            'suhosin.session.cryptua' => 'off',
            'zend.ze1_compatibility_mode' => 'off'
        }
    }
)