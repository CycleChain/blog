#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "Error: .env file not found!"
    exit 1
fi

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🚀 Starting Hugo deployment..."

# Build Hugo site
echo "📦 Building Hugo site..."
hugo --environment $HUGO_ENV --minify --buildFuture --buildDrafts -D

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Hugo build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Hugo build successful${NC}"

# Deploy with rsync
echo "📤 Deploying to server..."

if [ ! -z "$SSH_KEY_PATH" ]; then
    # Deploy using SSH key (recommended)
    rsync -avz --delete \
        -e "ssh -i $SSH_KEY_PATH -p $PORT" \
        public/ \
        $USER@$SERVER:$REMOTE_PATH
else
    # Deploy using password (requires sshpass)
    if [ ! -z "$PASSWORD" ]; then
        rsync -avz --delete \
            -e "sshpass -p '$PASSWORD' ssh -p $PORT" \
            public/ \
            $USER@$SERVER:$REMOTE_PATH
    else
        echo -e "${RED}❌ No authentication method specified!${NC}"
        exit 1
    fi
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo "🌐 Your site is live at: http://$SERVER"
else
    echo -e "${RED}❌ Deployment failed!${NC}"
    exit 1
fi