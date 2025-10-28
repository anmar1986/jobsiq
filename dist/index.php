<?php

use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// Set PHP upload temp directory (workaround for .htaccess not being applied)
$tempDir = __DIR__.'/../storage/tmp';
if (! is_dir($tempDir)) {
    mkdir($tempDir, 0777, true);
}
// Convert to absolute path and use Windows-style path separators
$absoluteTempDir = realpath($tempDir);
if ($absoluteTempDir === false) {
    // If realpath fails, try to create and get the path
    $absoluteTempDir = str_replace('/', DIRECTORY_SEPARATOR, $tempDir);
}
ini_set('upload_tmp_dir', $absoluteTempDir);
ini_set('sys_temp_dir', $absoluteTempDir);

// Determine if the application is in maintenance mode...
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
/** @var Application $app */
$app = require_once __DIR__.'/../bootstrap/app.php';

$app->handleRequest(Request::capture());
