<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class CreateAdminUser extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'admin:create
                            {--name= : The name of the admin user}
                            {--email= : The email of the admin user}
                            {--password= : The password of the admin user}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create a new admin user';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('Creating a new admin user...');
        $this->newLine();

        // Get name
        $name = $this->option('name') ?? $this->ask('What is the admin\'s name?');

        // Get email
        $email = $this->option('email') ?? $this->ask('What is the admin\'s email?');

        // Validate email
        $validator = Validator::make(['email' => $email], [
            'email' => 'required|email|unique:users,email',
        ]);

        if ($validator->fails()) {
            $this->error('Invalid email or email already exists.');

            return self::FAILURE;
        }

        // Get password
        $password = $this->option('password') ?? $this->secret('What is the admin\'s password? (min 8 characters)');

        // Validate password
        if (strlen($password) < 8) {
            $this->error('Password must be at least 8 characters long.');

            return self::FAILURE;
        }

        // Create admin user
        $user = User::create([
            'name' => $name,
            'email' => $email,
            'password' => Hash::make($password),
            'user_type' => 'company_owner',
            'is_admin' => true,
        ]);

        $this->newLine();
        $this->info('Admin user created successfully!');
        $this->newLine();
        $this->table(
            ['ID', 'Name', 'Email', 'Type', 'Admin'],
            [[$user->id, $user->name, $user->email, $user->user_type, $user->is_admin ? 'Yes' : 'No']]
        );

        return self::SUCCESS;
    }
}
