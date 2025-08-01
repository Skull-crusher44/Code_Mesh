#!/bin/bash

# Deployment script for Code-Sync project

echo "🚀 Starting Code-Sync deployment..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Run this script from the project root directory"
    exit 1
fi

# Function to deploy frontend to Vercel
deploy_frontend() {
    echo "📦 Deploying frontend to Vercel..."
    cd client
    
    # Install dependencies
    npm install
    
    # Build the project
    npm run build
    
    # Deploy to Vercel (requires vercel CLI)
    if command -v vercel &> /dev/null; then
        vercel --prod
        echo "✅ Frontend deployed to Vercel!"
    else
        echo "⚠️  Vercel CLI not found. Please install with: npm install -g vercel"
        echo "   Then run: vercel --prod from the client directory"
    fi
    
    cd ..
}

# Function to prepare backend for Render
prepare_backend() {
    echo "📦 Preparing backend for Render deployment..."
    cd server
    
    # Install dependencies
    npm install
    
    # Build the project
    npm run build
    
    echo "✅ Backend prepared for Render deployment!"
    echo "   Push your code to GitHub and connect the repository to Render"
    echo "   Render will automatically deploy using the render.yaml configuration"
    
    cd ..
}

# Function to prepare Docker deployment
prepare_docker() {
    echo "🐳 Preparing Docker deployment..."
    
    # Check if Docker is installed
    if command -v docker &> /dev/null; then
        echo "Building Docker images..."
        docker-compose build
        echo "✅ Docker images built successfully!"
        echo "   Run 'docker-compose up' to start the application"
    else
        echo "⚠️  Docker not found. Please install Docker to use this option"
    fi
}

# Main menu
echo "Choose deployment option:"
echo "1) Deploy frontend to Vercel"
echo "2) Prepare backend for Render"
echo "3) Prepare Docker deployment"
echo "4) Deploy all (Vercel + prepare Render)"

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        deploy_frontend
        ;;
    2)
        prepare_backend
        ;;
    3)
        prepare_docker
        ;;
    4)
        deploy_frontend
        prepare_backend
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo "🎉 Deployment process completed!"
