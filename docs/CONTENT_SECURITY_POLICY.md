# Content Security Policy (CSP) Configuration

## Overview

This application implements Content Security Policy headers to enhance security by preventing XSS attacks and other code injection vulnerabilities.

## What is CSP?

Content Security Policy (CSP) is a security standard that helps prevent:
- Cross-Site Scripting (XSS) attacks
- Code injection attacks
- Data theft
- Unauthorized resource loading

## Configuration

### Environment-Based Policies

The CSP middleware automatically applies different policies based on the environment:

#### Development Mode (`APP_DEBUG=true`)
- **Allows `unsafe-eval`**: Required for Vite HMR (Hot Module Replacement) and Vue DevTools
- **Allows `unsafe-inline`**: Required for inline scripts and styles
- **WebSocket connections**: Allowed for Vite HMR on `ws://localhost:3000`

#### Production Mode (`APP_DEBUG=false`)
- **Stricter policy**: Removes `unsafe-eval` for better security
- **Keeps `unsafe-inline`**: Required for Tailwind CSS dynamic classes
- **Secure connections only**: No WebSocket development connections

### Configuration File

Edit `config/csp.php` to customize CSP directives:

```php
'development' => [
    'script-src' => "'self' 'unsafe-eval' 'unsafe-inline'",
    'style-src' => "'self' 'unsafe-inline'",
    // ... more directives
],

'production' => [
    'script-src' => "'self' 'unsafe-inline'",
    'style-src' => "'self' 'unsafe-inline'",
    // ... more directives
]
```

### Environment Variables

Add to your `.env` file:

```bash
# Enable/disable CSP headers
CSP_ENABLED=true
```

## Browser Warnings

### "eval blocked by CSP" in Development

This is **normal** and expected when:
- Using Vue DevTools browser extension
- Running Vite dev server with HMR
- Using browser extensions that inject scripts

The development CSP already allows `unsafe-eval` to prevent these warnings from affecting functionality.

### Disabling CSP Temporarily

If you need to disable CSP for debugging:

```bash
# In .env
CSP_ENABLED=false
```

## Security Best Practices

### For Production

1. **Never use `unsafe-eval` in production** - It allows arbitrary code execution
2. **Minimize `unsafe-inline` usage** - Use nonces or hashes when possible
3. **Whitelist specific domains** - Instead of using wildcards
4. **Test thoroughly** - Ensure all functionality works with CSP enabled

### Customizing for Your Needs

If you need to load resources from external domains:

```php
// In config/csp.php
'production' => [
    'script-src' => "'self' https://cdn.example.com",
    'img-src' => "'self' data: https://images.example.com",
    // ...
]
```

## Testing CSP

### Browser Developer Tools

1. Open DevTools (F12)
2. Go to Console tab
3. Look for CSP violation messages
4. Adjust policy accordingly

### CSP Reporting

To enable CSP violation reporting:

```php
// In config/csp.php
'production' => [
    // ... existing directives
    'report-uri' => '/csp-report',
]
```

Then create an endpoint to receive reports.

## Common Issues

### Images Not Loading
- Add the domain to `img-src`
- Check if using `data:` URIs (already allowed)

### Styles Not Applying
- Verify `style-src` includes `'unsafe-inline'` for Tailwind
- Consider using nonces for critical inline styles

### Scripts Not Executing
- Check `script-src` directive
- Ensure external CDNs are whitelisted
- Verify no `eval()` usage in production code

## Middleware Implementation

The CSP middleware is automatically applied to all web routes:

```php
// bootstrap/app.php
$middleware->web(append: [
    \App\Http\Middleware\ContentSecurityPolicy::class,
]);
```

## References

- [MDN CSP Guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)
- [Content Security Policy Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
