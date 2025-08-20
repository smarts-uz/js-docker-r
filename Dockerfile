# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files for dependency installation
COPY package.json pnpm-lock.yaml ./

# Install pnpm globally
RUN npm i -g pnpm

# Install all dependencies (including devDependencies for build)
RUN pnpm i

# Copy source code
COPY . .

# Build Next.js app
RUN pnpm build

# Stage 2: Runtime
FROM node:22-alpine

WORKDIR /app

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy package files for production dependencies
COPY package.json pnpm-lock.yaml ./

# Install pnpm globally
RUN npm i -g pnpm

# Install only production dependencies
RUN pnpm i --prod

# Copy built Next.js output from builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Set non-root user
USER appuser

# Expose port (Next.js default)
EXPOSE 3000

# Set environment for production
ENV NODE_ENV=production

# Run Next.js app
CMD ["pnpm", "start"]