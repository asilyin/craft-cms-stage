<?php
/**
 * General Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/GeneralConfig.php.
 *
 * @see \craft\config\GeneralConfig
 */

use craft\config\GeneralConfig;
use craft\helpers\App;

return GeneralConfig::create()
    ->cpTrigger(getenv('CRAFT_CP_TRIGGER') ?: 'admin')
    ->defaultWeekStartDay(1)
    ->devMode(App::env('CRAFT_ENVIRONMENT') !== 'production')
    ->allowAdminChanges(App::env('CRAFT_ENVIRONMENT') !== 'production')
    ->disallowRobots(App::env('CRAFT_ENVIRONMENT') !== 'production');
