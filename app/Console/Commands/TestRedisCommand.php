<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Redis;

class TestRedisCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'redis:test {--clear : Clear test data after testing}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Test Redis connection and performance';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('🔧 Testing Redis Connection and Performance');
        $this->newLine();

        // Test 1: Basic Connection
        $this->testConnection();
        
        // Test 2: Cache Operations
        $this->testCacheOperations();
        
        // Test 3: Performance Comparison
        $this->testPerformance();
        
        // Test 4: Redis Info
        $this->showRedisInfo();

        if ($this->option('clear')) {
            $this->clearTestData();
        }

        return Command::SUCCESS;
    }

    protected function testConnection(): void
    {
        $this->info('📡 Test 1: Redis Connection');
        
        try {
            $redis = Redis::connection();
            $pong = $redis->ping();
            
            if ($pong) {
                $this->line('  ✓ Redis is responding');
                $this->line('  ✓ Connection: ' . config('database.redis.default.host') . ':' . config('database.redis.default.port'));
            }
        } catch (\Exception $e) {
            $this->error('  ✗ Redis connection failed: ' . $e->getMessage());
            return;
        }

        $this->newLine();
    }

    protected function testCacheOperations(): void
    {
        $this->info('💾 Test 2: Cache Operations');

        try {
            // Test Write
            $key = 'test_key_' . time();
            $value = 'Hello from Redis!';
            
            Cache::store('redis')->put($key, $value, 60);
            $this->line('  ✓ Cache write successful');

            // Test Read
            $retrieved = Cache::store('redis')->get($key);
            if ($retrieved === $value) {
                $this->line('  ✓ Cache read successful');
            } else {
                $this->error('  ✗ Cache read failed');
            }

            // Test Delete
            Cache::store('redis')->forget($key);
            $deleted = Cache::store('redis')->get($key);
            if ($deleted === null) {
                $this->line('  ✓ Cache delete successful');
            }

            // Test Complex Data
            $complexData = [
                'array' => [1, 2, 3],
                'string' => 'test',
                'nested' => ['key' => 'value']
            ];
            Cache::store('redis')->put('complex_test', $complexData, 60);
            $retrievedComplex = Cache::store('redis')->get('complex_test');
            
            if ($retrievedComplex === $complexData) {
                $this->line('  ✓ Complex data storage successful');
            }
            
            Cache::store('redis')->forget('complex_test');

        } catch (\Exception $e) {
            $this->error('  ✗ Cache operations failed: ' . $e->getMessage());
        }

        $this->newLine();
    }

    protected function testPerformance(): void
    {
        $this->info('⚡ Test 3: Performance Comparison');
        $iterations = 100;

        // Test Redis Cache
        $redisStart = microtime(true);
        for ($i = 0; $i < $iterations; $i++) {
            Cache::store('redis')->put("perf_test_{$i}", "value_{$i}", 60);
            Cache::store('redis')->get("perf_test_{$i}");
        }
        $redisTime = microtime(true) - $redisStart;

        // Test Database Cache (if available)
        $dbTime = null;
        try {
            $dbStart = microtime(true);
            for ($i = 0; $i < $iterations; $i++) {
                Cache::store('database')->put("perf_test_{$i}", "value_{$i}", 60);
                Cache::store('database')->get("perf_test_{$i}");
            }
            $dbTime = microtime(true) - $dbStart;
        } catch (\Exception $e) {
            $this->warn('  ⚠ Database cache not available for comparison');
        }

        // Clean up
        for ($i = 0; $i < $iterations; $i++) {
            Cache::store('redis')->forget("perf_test_{$i}");
            if ($dbTime !== null) {
                Cache::store('database')->forget("perf_test_{$i}");
            }
        }

        // Show results
        $this->line(sprintf('  Redis: %.4f seconds (%d ops)', $redisTime, $iterations * 2));
        if ($dbTime !== null) {
            $this->line(sprintf('  Database: %.4f seconds (%d ops)', $dbTime, $iterations * 2));
            $improvement = (($dbTime - $redisTime) / $dbTime) * 100;
            $this->line(sprintf('  ✓ Redis is %.1f%% faster', $improvement));
        }

        $this->newLine();
    }

    protected function showRedisInfo(): void
    {
        $this->info('📊 Test 4: Redis Information');

        try {
            $redis = Redis::connection();
            $info = $redis->info();

            if (isset($info['Server'])) {
                $this->line('  Redis Version: ' . ($info['Server']['redis_version'] ?? 'Unknown'));
            }
            
            if (isset($info['Memory'])) {
                $this->line('  Used Memory: ' . ($info['Memory']['used_memory_human'] ?? 'Unknown'));
                $this->line('  Peak Memory: ' . ($info['Memory']['used_memory_peak_human'] ?? 'Unknown'));
            }

            if (isset($info['Stats'])) {
                $this->line('  Total Commands: ' . ($info['Stats']['total_commands_processed'] ?? 'Unknown'));
                $this->line('  Keyspace Hits: ' . ($info['Stats']['keyspace_hits'] ?? '0'));
                $this->line('  Keyspace Misses: ' . ($info['Stats']['keyspace_misses'] ?? '0'));
                
                $hits = (int)($info['Stats']['keyspace_hits'] ?? 0);
                $misses = (int)($info['Stats']['keyspace_misses'] ?? 0);
                $total = $hits + $misses;
                
                if ($total > 0) {
                    $hitRate = ($hits / $total) * 100;
                    $this->line(sprintf('  Hit Rate: %.2f%%', $hitRate));
                }
            }

            // Count keys
            $keys = $redis->keys('*');
            $this->line('  Total Keys: ' . count($keys));

            // Show sample keys
            if (count($keys) > 0) {
                $this->line('  Sample Keys:');
                $sampleKeys = array_slice($keys, 0, 5);
                foreach ($sampleKeys as $key) {
                    $this->line('    - ' . $key);
                }
                if (count($keys) > 5) {
                    $this->line('    ... and ' . (count($keys) - 5) . ' more');
                }
            }

        } catch (\Exception $e) {
            $this->error('  ✗ Failed to get Redis info: ' . $e->getMessage());
        }

        $this->newLine();
    }

    protected function clearTestData(): void
    {
        $this->info('🧹 Clearing test data...');
        
        try {
            $redis = Redis::connection();
            $keys = $redis->keys('test_*');
            
            foreach ($keys as $key) {
                $redis->del($key);
            }
            
            $this->line('  ✓ Test data cleared (' . count($keys) . ' keys removed)');
        } catch (\Exception $e) {
            $this->error('  ✗ Failed to clear test data: ' . $e->getMessage());
        }

        $this->newLine();
    }
}
