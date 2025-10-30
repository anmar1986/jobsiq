<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\DB;

echo "=== TESTING COMPANY CREATION FLOW ===\n\n";

// 1. Check database connection
echo "1. Testing database connection...\n";
try {
    $pdo = DB::connection()->getPdo();
    echo "   ✓ Database connected: " . $pdo->getAttribute(PDO::ATTR_DRIVER_NAME) . "\n\n";
} catch (Exception $e) {
    echo "   ✗ Database connection failed: " . $e->getMessage() . "\n\n";
    exit(1);
}

// 2. Check if companies table exists
echo "2. Checking companies table...\n";
try {
    $tables = DB::select("SHOW TABLES LIKE 'companies'");
    if (count($tables) > 0) {
        echo "   ✓ Companies table exists\n";
        
        // Get column info
        $columns = DB::select("DESCRIBE companies");
        echo "   Columns: " . implode(', ', array_column($columns, 'Field')) . "\n\n";
    } else {
        echo "   ✗ Companies table does not exist\n\n";
        exit(1);
    }
} catch (Exception $e) {
    echo "   ✗ Error checking table: " . $e->getMessage() . "\n\n";
    exit(1);
}

// 3. Check Company model fillable fields
echo "3. Checking Company model...\n";
$company = new App\Models\Company();
$fillable = $company->getFillable();
echo "   Fillable fields (" . count($fillable) . "): \n";
foreach ($fillable as $field) {
    echo "     - $field\n";
}
echo "\n";

// 4. Check if logo/images are in fillable (they shouldn't be)
$hasLogo = in_array('logo', $fillable);
$hasImages = in_array('images', $fillable);
echo "   logo in fillable: " . ($hasLogo ? '✗ YES (WRONG!)' : '✓ NO (correct)') . "\n";
echo "   images in fillable: " . ($hasImages ? '✗ YES (WRONG!)' : '✓ NO (correct)') . "\n\n";

// 5. Check validation rules
echo "4. Checking StoreCompanyRequest validation...\n";
$request = new App\Http\Requests\StoreCompanyRequest();
$rules = $request->rules();
echo "   Total validation rules: " . count($rules) . "\n";
echo "   Logo validation: " . (isset($rules['logo']) ? implode(', ', (array)$rules['logo']) : 'not set') . "\n";
echo "   Images validation: " . (isset($rules['images']) ? implode(', ', (array)$rules['images']) : 'not set') . "\n\n";

// 6. Test CompanyController logic
echo "5. Checking CompanyController...\n";
$controllerPath = app_path('Http/Controllers/Api/CompanyController.php');
$controllerContent = file_get_contents($controllerPath);

if (strpos($controllerContent, "except(['logo', 'images', 'cover'])") !== false) {
    echo "   ✓ Controller excludes logo/images/cover from mass assignment\n";
} else {
    echo "   ✗ Controller does NOT exclude logo/images/cover properly\n";
}

if (strpos($controllerContent, 'uploadLogo') !== false) {
    echo "   ✓ Controller has uploadLogo method\n";
} else {
    echo "   ✗ Controller missing uploadLogo method\n";
}

echo "\n=== TEST COMPLETE ===\n";
