<?php

// Check PHP upload configuration
header('Content-Type: application/json');

$config = [
    'upload_max_filesize' => ini_get('upload_max_filesize'),
    'post_max_size' => ini_get('post_max_size'),
    'max_file_uploads' => ini_get('max_file_uploads'),
    'memory_limit' => ini_get('memory_limit'),
    'max_execution_time' => ini_get('max_execution_time'),
    'max_input_time' => ini_get('max_input_time'),
    'file_uploads' => ini_get('file_uploads') ? 'Enabled' : 'Disabled',
    'upload_tmp_dir' => ini_get('upload_tmp_dir'),
    'sys_temp_dir' => ini_get('sys_temp_dir'),
    'sys_get_temp_dir' => sys_get_temp_dir(),
];

// Convert to bytes for comparison
function convertToBytes($value)
{
    $value = trim($value);
    $last = strtolower($value[strlen($value) - 1]);
    $value = (int) $value;

    switch ($last) {
        case 'g':
            $value *= 1024;
            // fall through
        case 'm':
            $value *= 1024;
            // fall through
        case 'k':
            $value *= 1024;
    }

    return $value;
}

$config['upload_max_filesize_bytes'] = convertToBytes($config['upload_max_filesize']);
$config['post_max_size_bytes'] = convertToBytes($config['post_max_size']);

// Check if settings are adequate for 2MB uploads
$minRequired = 2 * 1024 * 1024; // 2MB in bytes
$config['can_upload_2mb'] = (
    $config['upload_max_filesize_bytes'] >= $minRequired &&
    $config['post_max_size_bytes'] >= $minRequired
);

$config['warnings'] = [];

if ($config['upload_max_filesize_bytes'] < $minRequired) {
    $config['warnings'][] = "upload_max_filesize ({$config['upload_max_filesize']}) is less than 2MB";
}

if ($config['post_max_size_bytes'] < $minRequired) {
    $config['warnings'][] = "post_max_size ({$config['post_max_size']}) is less than 2MB";
}

if ($config['post_max_size_bytes'] < $config['upload_max_filesize_bytes']) {
    $config['warnings'][] = 'post_max_size should be larger than upload_max_filesize';
}

if (empty($config['upload_tmp_dir'])) {
    $config['warnings'][] = 'upload_tmp_dir is NOT set - PHP will use system default';
} else {
    $tmpDir = $config['upload_tmp_dir'];
    $config['tmp_dir_exists'] = is_dir($tmpDir);
    $config['tmp_dir_writable'] = is_writable($tmpDir);
    
    if (!$config['tmp_dir_exists']) {
        $config['warnings'][] = "upload_tmp_dir ($tmpDir) does not exist";
    } elseif (!$config['tmp_dir_writable']) {
        $config['warnings'][] = "upload_tmp_dir ($tmpDir) is not writable";
    }
}

echo json_encode($config, JSON_PRETTY_PRINT);
