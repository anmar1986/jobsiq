<!DOCTYPE html>
<html dir="auto">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Form Submission</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans Arabic', sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background: linear-gradient(135deg, #3b82f6 0%, #a855f7 100%);
            color: white;
            padding: 30px;
            text-align: center;
            border-radius: 10px 10px 0 0;
        }
        .content {
            background: #ffffff;
            padding: 30px;
            border: 1px solid #e5e7eb;
            border-top: none;
        }
        .info-row {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .label {
            font-weight: 600;
            color: #3b82f6;
            margin-bottom: 5px;
        }
        .value {
            color: #1f2937;
            direction: auto;
            unicode-bidi: plaintext;
        }
        .message-box {
            background: #f9fafb;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #3b82f6;
            white-space: pre-wrap;
            word-wrap: break-word;
            direction: auto;
            unicode-bidi: plaintext;
            text-align: start;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #6b7280;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1 style="margin: 0;">New Contact Form Submission</h1>
        <p style="margin: 10px 0 0 0; opacity: 0.9;">JobsIQ Contact Form</p>
    </div>
    
    <div class="content">
        <div class="info-row">
            <div class="label">From:</div>
            <div class="value">{{ $name }}</div>
        </div>
        
        <div class="info-row">
            <div class="label">Email:</div>
            <div class="value"><a href="mailto:{{ $email }}">{{ $email }}</a></div>
        </div>
        
        <div class="info-row">
            <div class="label">Subject:</div>
            <div class="value">{{ $messageSubject }}</div>
        </div>
        
        <div class="info-row">
            <div class="label">Message:</div>
            <div class="message-box">{{ $messageContent }}</div>
        </div>
    </div>
    
    <div class="footer">
        <p>This email was sent from the JobsIQ contact form.</p>
        <p>Please reply directly to the sender's email address.</p>
    </div>
</body>
</html>
