# GitHub Actions Secrets Configuration

This document describes the secrets needed for CI/CD pipelines.

## Required Secrets

Navigate to: **Repository Settings** → **Secrets and variables** → **Actions**

### For Staging Deployment

- `STAGING_SSH_KEY`
  - Description: SSH private key for staging server
  - Example: Copy content from `~/.ssh/id_rsa`
  - How to generate:
    ```bash
    ssh-keygen -t rsa -b 4096 -C "github-actions@jobsiq.com"
    ```

- `STAGING_HOST`
  - Description: Staging server hostname or IP
  - Example: `staging.jobsiq.com` or `192.168.1.100`

- `STAGING_USER`
  - Description: SSH username for staging server
  - Example: `deployer` or `ubuntu`

- `STAGING_PATH`
  - Description: Deployment path on staging server
  - Example: `/var/www/jobsiq-staging`

### For Production Deployment

- `PRODUCTION_SSH_KEY`
  - Description: SSH private key for production server
  - Example: Copy content from production SSH key

- `PRODUCTION_HOST`
  - Description: Production server hostname or IP
  - Example: `jobsiq.com` or `production.server.com`

- `PRODUCTION_USER`
  - Description: SSH username for production server
  - Example: `deployer` or `ubuntu`

- `PRODUCTION_PATH`
  - Description: Deployment path on production server
  - Example: `/var/www/jobsiq`

### Optional Secrets

- `CODECOV_TOKEN`
  - Description: Token for uploading code coverage to Codecov
  - Get from: https://codecov.io/

- `SLACK_WEBHOOK`
  - Description: Webhook URL for Slack notifications
  - Get from: Slack App Settings

## Setting Up SSH Deployment

### 1. Generate SSH Key Pair on Local Machine

```bash
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy" -f ~/.ssh/github_deploy
```

### 2. Add Public Key to Server

Copy the public key to the server's authorized_keys:

```bash
ssh-copy-id -i ~/.ssh/github_deploy.pub user@your-server.com
```

Or manually:

```bash
cat ~/.ssh/github_deploy.pub | ssh user@server 'cat >> ~/.ssh/authorized_keys'
```

### 3. Add Private Key to GitHub Secrets

1. Copy the private key content:
   ```bash
   cat ~/.ssh/github_deploy
   ```

2. In GitHub:
   - Go to repository **Settings**
   - Click **Secrets and variables** → **Actions**
   - Click **New repository secret**
   - Name: `STAGING_SSH_KEY` or `PRODUCTION_SSH_KEY`
   - Paste the private key content
   - Click **Add secret**

### 4. Test SSH Connection

```bash
ssh -i ~/.ssh/github_deploy user@your-server.com
```

## Deployment Workflow

The CI/CD pipeline automatically:

1. **On Push to `develop` branch:**
   - Runs tests
   - Builds application
   - Deploys to **staging**

2. **On Push to `main` branch:**
   - Runs tests
   - Builds application
   - Deploys to **production**

## Manual Deployment Trigger

You can manually trigger deployment:

1. Go to **Actions** tab in GitHub
2. Select **CI/CD Pipeline** workflow
3. Click **Run workflow**
4. Select branch and environment

## Monitoring Deployments

### Check Deployment Status

- View in GitHub Actions tab
- Check deployment logs
- Monitor server health

### Rollback Procedure

If deployment fails:

1. SSH into server
2. Switch to previous release:
   ```bash
   cd /var/www/jobsiq
   ln -sfn releases/previous current
   php artisan config:cache
   php artisan route:cache
   supervisorctl restart all
   ```

## Environments in GitHub

Configure environments for approval workflows:

1. Go to **Settings** → **Environments**
2. Add `staging` and `production` environments
3. Configure protection rules:
   - Required reviewers for production
   - Wait timer before deployment
   - Deployment branches

## Notification Setup

### Slack Notifications

Add to workflow:

```yaml
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Deployment to ${{ env.ENVIRONMENT }} completed'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
  if: always()
```

### Email Notifications

GitHub automatically sends emails for:
- Failed workflows
- First successful run after failures

Configure in: **Repository Settings** → **Notifications**

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Rotate SSH keys** regularly (every 90 days)
3. **Use different keys** for staging and production
4. **Limit SSH key permissions** on servers
5. **Enable 2FA** on GitHub account
6. **Use environment-specific** `.env` files
7. **Review deployment logs** regularly

## Troubleshooting

### SSH Connection Failed

```bash
# Test SSH connection
ssh -vvv -i ~/.ssh/github_deploy user@server

# Check SSH key permissions (should be 600)
chmod 600 ~/.ssh/github_deploy

# Verify public key on server
cat ~/.ssh/authorized_keys
```

### Deployment Failed

1. Check GitHub Actions logs
2. SSH into server and check:
   ```bash
   tail -f /var/log/nginx/error.log
   tail -f storage/logs/laravel.log
   ```
3. Verify file permissions:
   ```bash
   ls -la storage/
   ls -la bootstrap/cache/
   ```

### Database Migration Issues

```bash
# Check migration status
php artisan migrate:status

# Rollback last migration
php artisan migrate:rollback --step=1

# Fresh migration (⚠️ destroys data)
php artisan migrate:fresh --force
```

## Support

For deployment issues:
- Check workflow logs in GitHub Actions
- Review server logs
- Contact DevOps team
- Create issue in repository
