<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Feature Flags
    |--------------------------------------------------------------------------
    |
    | This file is used to enable/disable features in the application.
    | Set these values to true or false to toggle features on or off.
    |
    */

    /*
    |--------------------------------------------------------------------------
    | Free CVs Feature
    |--------------------------------------------------------------------------
    |
    | When enabled, company owners can browse publicly available CVs from
    | job seekers. When disabled, the entire feature is hidden and inaccessible.
    |
    */
    'free_cvs_enabled' => env('FEATURE_FREE_CVS', true),

];
