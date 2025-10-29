/**
 * Copy text to clipboard with fallback for older browsers
 * @param text - The text to copy
 * @returns Promise that resolves when copy is successful
 */
export async function copyToClipboard(text: string): Promise<void> {
  // Try modern Clipboard API first
  if (navigator.clipboard && typeof navigator.clipboard.writeText === 'function') {
    try {
      await navigator.clipboard.writeText(text)
      return
    } catch (err) {
      // Fall through to legacy method if clipboard API fails
      console.warn('Clipboard API failed, trying fallback method', err)
    }
  }

  // Fallback for older browsers or non-secure contexts
  return new Promise((resolve, reject) => {
    const textarea = document.createElement('textarea')
    textarea.value = text
    textarea.setAttribute('readonly', '')
    textarea.style.position = 'absolute'
    textarea.style.left = '-9999px'
    document.body.appendChild(textarea)

    const selected =
      document.getSelection()?.rangeCount && document.getSelection()!.rangeCount > 0
        ? document.getSelection()!.getRangeAt(0)
        : null

    textarea.select()

    try {
      const successful = document.execCommand('copy')
      document.body.removeChild(textarea)

      if (selected && document.getSelection()) {
        document.getSelection()!.removeAllRanges()
        document.getSelection()!.addRange(selected)
      }

      if (successful) {
        resolve()
      } else {
        reject(new Error('Copy command failed'))
      }
    } catch (err) {
      document.body.removeChild(textarea)
      reject(err)
    }
  })
}
