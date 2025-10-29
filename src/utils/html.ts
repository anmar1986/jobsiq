/**
 * Strips HTML tags from a string using DOMParser for robust HTML handling
 * @param html - The HTML string to strip tags from
 * @returns Plain text without HTML tags
 */
export function stripHtmlTags(html: string): string {
  if (!html) return ''
  
  // Create a temporary div element to parse HTML
  const div = document.createElement('div')
  div.innerHTML = html
  
  // Get text content (textContent is more reliable than innerText)
  return div.textContent || div.innerText || ''
}

/**
 * Strips HTML tags and truncates text to a specified length
 * @param html - The HTML string to process
 * @param maxLength - Maximum length of the output string
 * @param suffix - Suffix to add if text is truncated (default: '...')
 * @returns Truncated plain text
 */
export function stripAndTruncate(html: string, maxLength: number, suffix = '...'): string {
  const text = stripHtmlTags(html)
  
  if (text.length <= maxLength) {
    return text
  }
  
  return text.substring(0, maxLength).trim() + suffix
}
