/**
 * Get the currency symbol based on currency code
 */
export const getCurrencySymbol = (currencyCode: string): string => {
  const symbols: Record<string, string> = {
    'USD': '$',
    'IQD': 'IQD',
    'EUR': '€',
    'GBP': '£',
  }
  return symbols[currencyCode?.toUpperCase()] || currencyCode || '$'
}

/**
 * Format salary with appropriate currency symbol
 */
export const formatSalaryWithCurrency = (
  amount: number,
  currencyCode: string = 'USD'
): string => {
  const symbol = getCurrencySymbol(currencyCode)
  const formattedAmount = amount.toLocaleString()
  
  // For IQD and other non-symbol currencies, put code after the number
  if (currencyCode?.toUpperCase() === 'IQD' || symbol === currencyCode) {
    return `${formattedAmount} ${symbol}`
  }
  
  // For currencies with symbols like $, €, £, put symbol before the number
  return `${symbol}${formattedAmount}`
}

/**
 * Format salary range with currency
 */
export const formatSalaryRange = (
  min: number,
  max: number,
  currencyCode: string = 'USD',
  period?: string | null
): string => {
  const symbol = getCurrencySymbol(currencyCode)
  const formattedMin = min.toLocaleString()
  const formattedMax = max.toLocaleString()
  const periodText = period ? `/${period}` : ''
  
  // For IQD and other non-symbol currencies
  if (currencyCode?.toUpperCase() === 'IQD' || symbol === currencyCode) {
    return `${formattedMin} - ${formattedMax} ${symbol}${periodText}`
  }
  
  // For currencies with symbols
  return `${symbol}${formattedMin} - ${symbol}${formattedMax}${periodText}`
}
