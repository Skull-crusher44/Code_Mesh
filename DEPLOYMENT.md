# 🚀 Code-Sync Deployment Guide

This guide covers deploying Code-Sync with backend on Render and frontend on Vercel, plus Docker deployment.

## 📋 Prerequisites

- Node.js 18+ installed
- Git repository set up
- GitHub account
- Vercel account (free tier available)
- Render account (free tier available)

## 🔧 Environment Variables

### Backend (.env in server directory)
```bash
NODE_ENV=production
PORT=10000
CORS_ORIGIN=https://your-frontend-domain.vercel.app
```

### Frontend (.env in client directory)
```bash
VITE_BACKEND_URL=https://your-backend-app.onrender.com
```

## 🌐 Deployment Steps

### 1. Backend Deployment (Render)

1. **Push code to GitHub**
   ```bash
   git add .
   git commit -m "Prepare for deployment"
   git push origin main
   ```

2. **Connect to Render**
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select the repository

3. **Configure Render Service**
   - **Name**: `code-sync-backend`
   - **Environment**: `Node`
   - **Build Command**: `cd server && npm install && npm run build`
   - **Start Command**: `cd server && npm start`
   - **Auto-Deploy**: `Yes`

4. **Set Environment Variables**
   - `NODE_ENV` = `production`
   - `PORT` = `10000` (Render sets this automatically)

5. **Deploy**
   - Click "Create Web Service"
   - Wait for deployment (5-10 minutes)
   - Copy the service URL (e.g., `https://your-app.onrender.com`)

### 2. Frontend Deployment (Vercel)

1. **Install Vercel CLI** (optional)
   ```bash
   npm install -g vercel
   ```

2. **Set Environment Variable**
   - Create `.env.local` in client directory:
   ```bash
   VITE_BACKEND_URL=https://your-backend-app.onrender.com
   ```

3. **Deploy to Vercel**

   **Option A: Using Vercel CLI**
   ```bash
   cd client
   vercel
   # Follow prompts, set environment variables
   vercel --prod
   ```

   **Option B: Using Vercel Dashboard**
   - Go to [Vercel Dashboard](https://vercel.com/dashboard)
   - Click "New Project"
   - Import your GitHub repository
   - Set root directory to `client`
   - Add environment variable: `VITE_BACKEND_URL`
   - Deploy

### 3. Docker Deployment (Alternative)

1. **Create production docker-compose.yml**
   ```yaml
   version: '3.8'
   services:
     backend:
       build: 
         context: ./server
         dockerfile: Dockerfile
       ports:
         - "3000:3000"
       environment:
         - NODE_ENV=production
         - PORT=3000
       
     frontend:
       build:
         context: ./client
         dockerfile: Dockerfile
       ports:
         - "80:80"
       environment:
         - VITE_BACKEND_URL=http://localhost:3000
       depends_on:
         - backend
   ```

2. **Deploy with Docker**
   ```bash
   docker-compose up --build -d
   ```

## 🔗 Post-Deployment

### Update CORS Settings
Update your backend's CORS configuration with your frontend URL:

```typescript
// In server/src/server.ts
const io = new Server(server, {
    cors: {
        origin: "https://your-frontend.vercel.app",
        methods: ["GET", "POST"]
    }
});
```

### Update Frontend URL
Update your frontend to point to the Render backend:

```bash
# In client/.env.production
VITE_BACKEND_URL=https://your-backend.onrender.com
```

## 🔍 Health Checks

Add a health check endpoint to your backend:

```typescript
// In server/src/server.ts
app.get('/health', (req, res) => {
    res.status(200).json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});
```

## 🚨 Troubleshooting

### Common Issues

1. **CORS Errors**
   - Ensure backend CORS is configured with frontend URL
   - Check environment variables are set correctly

2. **Build Failures**
   - Verify Node.js version compatibility
   - Check all dependencies are in package.json
   - Ensure TypeScript builds without errors

3. **Environment Variables Not Working**
   - Vercel: Set in dashboard under Settings → Environment Variables
   - Render: Set in dashboard under Environment tab

4. **WebSocket Connection Issues**
   - Ensure Socket.IO CORS is properly configured
   - Check if your hosting platform supports WebSockets

### Logs and Debugging

**Render Logs**:
- Go to your service → Logs tab
- Check for startup errors

**Vercel Logs**:
- Go to your project → Functions tab
- Check build and runtime logs

## 📊 Monitoring

- **Render**: Built-in monitoring dashboard
- **Vercel**: Analytics and Web Vitals
- **Custom**: Add logging service (LogRocket, Sentry)

## 💰 Cost Considerations

- **Render Free Tier**: 750 hours/month, sleeps after 15min inactivity
- **Vercel Free Tier**: 100GB bandwidth, hobby projects
- **Upgrade**: Consider paid plans for production use

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section
2. Review platform documentation
3. Open an issue in the repository

---

Happy deploying! 🎉
