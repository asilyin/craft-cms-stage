<?php
/**
 * Database Configuration
 *
 * All of your system's database connection settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/DbConfig.php.
 *
 * @see \craft\config\DbConfig
 */

use craft\config\DbConfig;

return DbConfig::create()
    ->driver(App::env('CRAFT_DB_DRIVER') ?: 'mysql')
    ->server(App::env('CRAFT_DB_SERVER') ?: '127.0.0.1')
    ->port(App::env('CRAFT_DB_PORT') ?: 3306)
    ->database(App::env('CRAFT_DB_DATABASE'))
    ->user(App::env('CRAFT_DB_USER') ?: 'root')
    ->password(App::env('CRAFT_DB_PASSWORD') ?: '')
    ->schema(App::env('CRAFT_DB_SCHEMA') ?: 'public')
    ->tablePrefix(App::env('CRAFT_DB_TABLE_PREFIX') ?: '');
