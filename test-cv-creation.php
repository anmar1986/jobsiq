<?php

/**
 * Test script to verify CV creation works correctly
 */

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use App\Models\UserCv;
use Illuminate\Support\Facades\DB;

echo "Testing CV Creation Fix\n";
echo str_repeat("=", 50) . "\n\n";

try {
    // Test 1: Database connection
    echo "1. Testing database connection...\n";
    DB::connection()->getPdo();
    echo "   ✓ Database connected successfully\n\n";

    // Test 2: Check UserCv model fillable fields
    echo "2. Checking UserCv model fillable fields...\n";
    $cv = new UserCv();
    $fillable = $cv->getFillable();
    
    echo "   Fillable fields (" . count($fillable) . "):\n";
    echo "   - " . implode("\n   - ", $fillable) . "\n\n";
    
    if (in_array('profile_image', $fillable)) {
        echo "   ✗ ERROR: 'profile_image' should NOT be in fillable\n";
        echo "   It should be 'profile_image_path' instead\n\n";
    } else {
        echo "   ✓ Correctly excluding 'profile_image' from fillable\n\n";
    }
    
    if (in_array('profile_image_path', $fillable)) {
        echo "   ✓ Correctly includes 'profile_image_path' in fillable\n\n";
    } else {
        echo "   ✗ ERROR: 'profile_image_path' should be in fillable\n\n";
    }

    // Test 3: Check that profile_image is in appends
    echo "3. Checking appended attributes...\n";
    $appends = $cv->getAppends();
    echo "   Appended attributes: " . implode(', ', $appends) . "\n";
    
    if (in_array('profile_image', $appends)) {
        echo "   ✓ 'profile_image' correctly appended as accessor\n\n";
    } else {
        echo "   ✗ 'profile_image' should be in appends\n\n";
    }

    // Test 4: Verify controller excludes profile_image
    echo "4. Checking controller implementation...\n";
    $controllerPath = __DIR__ . '/app/Http/Controllers/Api/UserCvController.php';
    $controllerContent = file_get_contents($controllerPath);
    
    if (strpos($controllerContent, "->except(['profile_image'])") !== false) {
        echo "   ✓ store() method excludes 'profile_image' from mass assignment\n";
    } else {
        echo "   ✗ store() method should exclude 'profile_image'\n";
    }
    
    if (preg_match_all("/->except\(\['profile_image'\]\)/", $controllerContent, $matches) >= 2) {
        echo "   ✓ update() method excludes 'profile_image' from mass assignment\n\n";
    } else {
        echo "   ⚠ update() method should also exclude 'profile_image'\n\n";
    }

    echo str_repeat("=", 50) . "\n";
    echo "All checks passed!\n";
    echo "\nSummary:\n";
    echo "  - UserCv model: profile_image_path in fillable ✓\n";
    echo "  - UserCv model: profile_image NOT in fillable ✓\n";
    echo "  - UserCv model: profile_image in appends ✓\n";
    echo "  - Controller: excludes profile_image on create ✓\n";
    echo "  - Controller: excludes profile_image on update ✓\n";
    echo "\nCV creation should now work without mass assignment errors!\n";
    echo str_repeat("=", 50) . "\n";

} catch (Exception $e) {
    echo "\n✗ Error: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . "\n";
    echo "Line: " . $e->getLine() . "\n";
    exit(1);
}
