# Dockerfile for Code Execution Service
FROM node:18-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    python3-dev \
    py3-pip \
    bash \
    curl \
    wget \
    git

# Install Node.js dependencies
COPY package.json .
RUN npm install --only=production

# Install Python packages for code execution
RUN pip3 install --no-cache-dir \
    flask \
    psutil \
    subprocess.run \
    yaml \
    requests

# Copy server code
COPY server.js .

# Create executions directory
RUN mkdir -p /app/executions

# Set permissions
RUN chown -R node:node /app

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

USER node

EXPOSE 5000

CMD ["node", "server.js"]