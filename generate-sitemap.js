/**
 * Sitemap Generator for Multilingual SEO
 * 
 * This script generates separate sitemaps for English and Arabic versions
 * following Google's best practices for multilingual websites.
 * 
 * Usage:
 *   node generate-sitemap.js
 * 
 * Output:
 *   public/sitemap-en.xml
 *   public/sitemap-ar.xml
 *   public/sitemap-index.xml
 */

import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// Configuration
const SITE_URL = 'https://jobs.iq'
const OUTPUT_DIR = path.join(__dirname, 'public')

// Static pages (add your static routes here)
const staticPages = [
  { path: '/', priority: 1.0, changefreq: 'daily' },
  { path: '/jobs', priority: 0.9, changefreq: 'daily' },
  { path: '/companies', priority: 0.9, changefreq: 'daily' },
  { path: '/about', priority: 0.5, changefreq: 'monthly' },
  { path: '/login', priority: 0.3, changefreq: 'monthly' },
  { path: '/register', priority: 0.3, changefreq: 'monthly' },
]

// Generate XML header
const xmlHeader = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">
`

const xmlFooter = `</urlset>`

/**
 * Generate URL entry with alternate language links
 */
function generateUrlEntry(path, locale, priority, changefreq) {
  const currentUrl = `${SITE_URL}/${locale}${path}`
  
  return `  <url>
    <loc>${currentUrl}</loc>
    <xhtml:link rel="alternate" hreflang="en" href="${SITE_URL}/en${path}"/>
    <xhtml:link rel="alternate" hreflang="ar" href="${SITE_URL}/ar${path}"/>
    <xhtml:link rel="alternate" hreflang="x-default" href="${SITE_URL}/en${path}"/>
    <lastmod>${new Date().toISOString().split('T')[0]}</lastmod>
    <changefreq>${changefreq}</changefreq>
    <priority>${priority}</priority>
  </url>
`
}

/**
 * Generate sitemap for a specific locale
 */
function generateLocaleSitemap(locale) {
  let xml = xmlHeader
  
  // Add static pages
  staticPages.forEach(page => {
    xml += generateUrlEntry(page.path, locale, page.priority, page.changefreq)
  })
  
  xml += xmlFooter
  return xml
}

/**
 * Generate sitemap index file
 */
function generateSitemapIndex() {
  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>${SITE_URL}/sitemap-en.xml</loc>
    <lastmod>${new Date().toISOString().split('T')[0]}</lastmod>
  </sitemap>
  <sitemap>
    <loc>${SITE_URL}/sitemap-ar.xml</loc>
    <lastmod>${new Date().toISOString().split('T')[0]}</lastmod>
  </sitemap>
</sitemapindex>
`
  return xml
}

/**
 * Main execution
 */
function main() {
  console.log('🗺️  Generating multilingual sitemaps...')
  
  // Ensure output directory exists
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true })
  }
  
  // Generate English sitemap
  const enSitemap = generateLocaleSitemap('en')
  const enPath = path.join(OUTPUT_DIR, 'sitemap-en.xml')
  fs.writeFileSync(enPath, enSitemap, 'utf-8')
  console.log('✅ Generated: sitemap-en.xml')
  
  // Generate Arabic sitemap
  const arSitemap = generateLocaleSitemap('ar')
  const arPath = path.join(OUTPUT_DIR, 'sitemap-ar.xml')
  fs.writeFileSync(arPath, arSitemap, 'utf-8')
  console.log('✅ Generated: sitemap-ar.xml')
  
  // Generate sitemap index
  const indexSitemap = generateSitemapIndex()
  const indexPath = path.join(OUTPUT_DIR, 'sitemap.xml')
  fs.writeFileSync(indexPath, indexSitemap, 'utf-8')
  console.log('✅ Generated: sitemap.xml (index)')
  
  console.log(`\n📊 Summary:`)
  console.log(`   - Static pages: ${staticPages.length}`)
  console.log(`   - Languages: en, ar`)
  console.log(`   - Total URLs: ${staticPages.length * 2}`)
  console.log('\n💡 Next steps:')
  console.log('   1. Add dynamic URLs (jobs, companies) to this script')
  console.log('   2. Submit sitemaps to Google Search Console')
  console.log(`   3. Add to robots.txt: Sitemap: ${SITE_URL}/sitemap.xml`)
}

// Run the generator
main()
