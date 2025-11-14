<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Content Security Policy Configuration
    |--------------------------------------------------------------------------
    |
    | Configure CSP directives for your application. Different policies
    | are applied based on the environment (development vs production).
    |
    */

    'enabled' => env('CSP_ENABLED', true),

    'development' => [
        'script-src' => "'self' 'unsafe-eval' 'unsafe-inline'",
        'style-src' => "'self' 'unsafe-inline'",
        'img-src' => "'self' data: https:",
        'font-src' => "'self' data:",
        'connect-src' => "'self' http://localhost:8000 http://localhost:3000 ws://localhost:3000",
        'default-src' => "'self'",
        'object-src' => "'none'",
        'base-uri' => "'self'",
        'form-action' => "'self'",
    ],

    'production' => [
        'script-src' => "'self' 'unsafe-inline'",
        'style-src' => "'self' 'unsafe-inline'",
        'img-src' => "'self' data: https:",
        'font-src' => "'self' data:",
        'connect-src' => "'self'",
        'default-src' => "'self'",
        'object-src' => "'none'",
        'base-uri' => "'self'",
        'form-action' => "'self'",
        'frame-ancestors' => "'none'",
        'upgrade-insecure-requests' => '',
    ],
];
