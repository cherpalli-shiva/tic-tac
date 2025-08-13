# Dockerfile
# ---- build stage ----
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---- runtime stage ----
FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
# minimal hardening
RUN rm -rf /etc/nginx/conf.d/* \
 && printf 'server { listen 80; root /usr/share/nginx/html; index index.html; \
 try_files $uri /index.html; }' > /etc/nginx/conf.d/default.conf
EXPOSE 80