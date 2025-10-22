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

        $updated = 0;

        UserCv::chunk(100, function ($cvs) use (&$updated) {
            foreach ($cvs as $cv) {
                $baseSlug = $cv->title ?: $cv->full_name;
                $originalSlug = Str::slug($baseSlug);

                // Batch check for existing slugs to avoid N+1 queries
                $possibleSlugs = [$originalSlug];
                for ($i = 1; $i <= 20; $i++) {
                    $possibleSlugs[] = $originalSlug . '-' . $i;
                }
                
                $existingSlugs = UserCv::where('id', '!=', $cv->id)
                    ->whereIn('slug', $possibleSlugs)
                    ->pluck('slug')
                    ->all();
                $slugSet = array_flip($existingSlugs);
                
                $slug = $originalSlug;
                foreach ($possibleSlugs as $candidate) {
                    if (!isset($slugSet[$candidate])) {
                        $slug = $candidate;
                        break;
                    }
                }

                // Only update if slug has changed
                if ($cv->slug !== $slug) {
                    $cv->slug = $slug;
                    $cv->save();
                    $updated++;
                    $this->line("Updated: {$cv->full_name} -> {$slug}");
                }
            }
        });

        $this->info("Regeneration complete! Updated {$updated} CV slug(s).");

        return 0;
    }
}
