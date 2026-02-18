FROM python:3.11-slim

# Switch to root for setup
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    dos2unix \
    gcc \
    g++ \
    make \
    libssl-dev \
    libpq-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /home/hummingbot/conf /home/hummingbot/logs /home/hummingbot/data /home/hummingbot/scripts /home/hummingbot/certs

# Copy startup script
COPY start.sh /home/hummingbot/start.sh

# Convert line endings and set permissions
RUN dos2unix /home/hummingbot/start.sh && chmod +x /home/hummingbot/start.sh

# Clone and install Hummingbot
WORKDIR /tmp
RUN git clone https://github.com/hummingbot/hummingbot.git && \
    cd hummingbot && \
    pip3 install --no-cache-dir -e .

# Expose port
EXPOSE 8080

# Start Hummingbot
WORKDIR /home/hummingbot
CMD ["/bin/bash", "/home/hummingbot/start.sh"]
