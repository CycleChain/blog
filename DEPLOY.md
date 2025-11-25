# Hugo Blog Deployment Guide

This guide explains how to deploy a Hugo blog on `cyclechain.io/blog` path with CloudFlare SSL.

**Site Structure:**
- `cyclechain.io` → React SPA (existing)
- `cyclechain.io/blog` → Hugo blog (new)

## Requirements

- Ubuntu/Debian server with NGINX
- cyclechain.io domain in CloudFlare
- Hugo installed locally

## 1. CloudFlare SSL Setup

### 1.1 Create Origin Certificate

1. CloudFlare Dashboard → **SSL/TLS** → **Origin Server**
2. Click **Create Certificate**
3. Settings:
   - Private key type: RSA (2048)
   - Validity: 15 years
   - Hostnames: `cyclechain.io`, `*.cyclechain.io`
4. Save both **Origin Certificate** and **Private Key** (shown only once!)

### 1.2 Set SSL Mode

Go to **SSL/TLS** → **Overview** and set mode to **Full (strict)**

## 2. Server Setup

### 2.1 Install Certificates

```bash
# Create directory
sudo mkdir -p /etc/nginx/ssl/cyclechain.io

# Save certificate
sudo nano /etc/nginx/ssl/cyclechain.io/cert.pem
# Paste Origin Certificate, save with CTRL+X, Y, Enter

# Save private key
sudo nano /etc/nginx/ssl/cyclechain.io/key.pem
# Paste Private Key, save with CTRL+X, Y, Enter

# Set permissions
sudo chmod 644 /etc/nginx/ssl/cyclechain.io/cert.pem
sudo chmod 600 /etc/nginx/ssl/cyclechain.io/key.pem
```

### 2.2 Create Blog Directory

```bash
sudo mkdir -p /var/www/cyclechain.io/blog
sudo chown -R $USER:$USER /var/www/cyclechain.io/blog
```

**Directory Structure:**
```
/var/www/cyclechain.io/
├── index.html          # React SPA files (existing)
├── assets/
├── favicon.ico
├── ...
└── blog/               # Hugo blog (new)
    ├── index.html
    ├── posts/
    └── ...
```

### 2.3 NGINX Configuration

```bash
sudo nano /etc/nginx/sites-available/cyclechain.io
```

Add or update with this configuration:

```nginx
# HTTP to HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name cyclechain.io www.cyclechain.io;
    return 301 https://cyclechain.io$request_uri;
}

# Main site
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name cyclechain.io;

    # SSL
    ssl_certificate /etc/nginx/ssl/cyclechain.io/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/cyclechain.io/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    
    # Root for React SPA
    root /var/www/cyclechain.io;
    index index.html;

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;

    # Hugo Blog
    location /blog {
        alias /var/www/cyclechain.io/blog;
        try_files $uri $uri/ =404;
    }

    # React SPA routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static files
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### 2.4 Enable and Test

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/cyclechain.io /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload NGINX
sudo systemctl reload nginx
```

## 3. Hugo Configuration

Edit `config.toml` (or `hugo.toml`):

```toml
baseURL = 'https://cyclechain.io/blog/'
languageCode = 'en'
title = 'CycleChain Blog'
canonifyURLs = true
relativeURLs = false

[permalinks]
  posts = '/blog/posts/:slug/'
```

Or `config.yaml`:

```yaml
baseURL: https://cyclechain.io/blog/
languageCode: en
title: CycleChain Blog
canonifyURLs: true
relativeURLs: false
permalinks:
  posts: /blog/posts/:slug/
```

## 4. Deployment

**Recommended: Build locally and rsync**

This approach is safer because:
- Server doesn't need Hugo installed
- Build errors don't affect production
- Faster deployment (only file transfer)

```bash
# Local: Build
cd ~/hugo-blog-project
hugo --minify

# Deploy to server
rsync -avz --delete public/ user@your-server-ip:/var/www/cyclechain.io/blog/

# On server: Fix permissions
ssh user@your-server-ip
sudo chown -R www-data:www-data /var/www/cyclechain.io/blog
sudo find /var/www/cyclechain.io/blog -type d -exec chmod 755 {} \;
sudo find /var/www/cyclechain.io/blog -type f -exec chmod 644 {} \;
```

**Alternative: Build on server**

Only if you have CI/CD or prefer this workflow:

```bash
# On server: Install Hugo
ssh user@your-server-ip
wget https://github.com/gohugoio/hugo/releases/download/v0.xxx.x/hugo_extended_0.xxx.x_Linux-64bit.tar.gz
sudo tar -C /usr/local/bin -xzf hugo_extended_*.tar.gz
rm hugo_extended_*.tar.gz

# Clone/pull your repo
cd /var/www/cyclechain.io
git clone your-repo-url blog-source
cd blog-source
hugo --minify -d /var/www/cyclechain.io/blog
```

## 5. Testing

```bash
# Test blog access
curl -I https://cyclechain.io/blog

# Check logs
sudo tail -f /var/log/nginx/access.log | grep "/blog"
```

Visit in browser:
- `https://cyclechain.io/blog` → Blog homepage
- `https://cyclechain.io/blog/posts/first-post` → Post page

## 6. Update Workflow

Create `deploy.sh` script:

```bash
#!/bin/bash
set -e

echo "🚀 Building Hugo blog..."
cd ~/hugo-blog-project
hugo --minify

echo "📦 Deploying to server..."
rsync -avz --delete public/ user@your-server-ip:/var/www/cyclechain.io/blog/

echo "✅ Done! Visit: https://cyclechain.io/blog"
```

Make executable and use:
```bash
chmod +x deploy.sh
./deploy.sh
```

## 7. SEO Setup

### robots.txt

Add to `/var/www/cyclechain.io/robots.txt`:

```
User-agent: *
Allow: /
Allow: /blog/

Sitemap: https://cyclechain.io/blog/sitemap.xml
```

### Sitemap

Hugo automatically generates `https://cyclechain.io/blog/sitemap.xml`

## 8. Common Issues

**404 on blog:**
```bash
ls -la /var/www/cyclechain.io/blog/index.html
sudo nginx -t
```

**CSS not loading:**
Check `baseURL = 'https://cyclechain.io/blog/'` in config

**Permission denied:**
```bash
sudo chown -R www-data:www-data /var/www/cyclechain.io/blog
```

## Quick Reference

```bash
# Build and deploy
hugo --minify && rsync -avz --delete public/ user@server:/var/www/cyclechain.io/blog/

# Check logs
sudo tail -f /var/log/nginx/access.log | grep "/blog"

# Test NGINX
sudo nginx -t && sudo systemctl reload nginx

# Fix permissions
sudo chown -R www-data:www-data /var/www/cyclechain.io/blog
```

---

**Deployment method recommendation: Use rsync** ✅

It's more reliable, faster, and doesn't require Hugo on the server.