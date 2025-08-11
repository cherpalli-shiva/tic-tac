# Stage 1: Build the app
FROM node:18-alpine AS builder

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json first (for caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the project (output usually goes to /app/dist)
RUN npm run build

# Stage 2: Serve the built app with nginx
FROM nginx:stable-alpine

# Copy built files from builder stage to nginx html folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx config if needed (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx (default command)
CMD ["nginx", "-g", "daemon off;"]
