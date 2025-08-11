### --- Build Stage --- ###
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm ci

COPY . .

RUN npm run build

### --- Production Stage --- ###
FROM nginx:alpine AS production

COPY --from=builder /app/dist /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf /etc/nginx/conf.d/default.conf

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
