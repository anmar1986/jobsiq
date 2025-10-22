<?php

namespace App\Console\Commands;

use App\Models\UserCv;
use Illuminate\Console\Command;
use Illuminate\Support\Str;

class RegenerateCvSlugs extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'cvs:regenerate-slugs';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Regenerate CV slugs to use clean format (title/name only)';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Starting CV slug regeneration...');
        
        $cvs = UserCv::all();
        $updated = 0;
        
        foreach ($cvs as $cv) {
            $baseSlug = $cv->title ?: $cv->full_name;
            $slug = Str::slug($baseSlug);
            
            // Check if slug already exists (globally, not just per user)
            $counter = 1;
            $originalSlug = $slug;
            
            while (UserCv::where('slug', $slug)->where('id', '!=', $cv->id)->exists()) {
                $slug = $originalSlug.'-'.$counter;
                $counter++;
            }
            
            // Only update if slug has changed
            if ($cv->slug !== $slug) {
                $cv->slug = $slug;
                $cv->save();
                $updated++;
                $this->line("Updated: {$cv->full_name} -> {$slug}");
            }
        }
        
        $this->info("Regeneration complete! Updated {$updated} CV slug(s).");
        
        return 0;
    }
}
