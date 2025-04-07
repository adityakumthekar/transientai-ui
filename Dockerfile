# Build stage
FROM node:18-bullseye AS builder
WORKDIR /app

# Skip canvas build tools entirely

# Copy dependency files and install dependencies
COPY package*.json ./

# Skip optional deps like canvas
ENV npm_config_optional=false
RUN npm ci

# Copy app code and build
COPY . .
RUN npm run build

# Final runtime container
FROM node:18-slim
WORKDIR /app

# No canvas runtime deps needed either

# Copy build output and node_modules from builder stage
COPY --from=builder /app ./ 

EXPOSE 8080
ENV PORT 8080
CMD ["npm", "start"]
