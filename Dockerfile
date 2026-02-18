FROM python:3.10-slim

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
    && rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip3 install --no-cache-dir \
    pandas \
    numpy \
    sqlalchemy \
    requests \
    pydantic \
    aiohttp \
    web3 \
    cryptography \
    pyjwt \
    urllib3 \
    pyyaml \
    tabulate \
    scipy \
    commlib-py \
    cachetools \
    psutil \
    ujson \
    tqdm \
    prompt_toolkit \
    protobuf \
    eth-account \
    bip-utils \
    safe-pyshajs \
    scalecodec \
    xrpl-py

# Create directories
RUN mkdir -p /home/hummingbot/conf /home/hummingbot/logs /home/hummingbot/data /home/hummingbot/scripts /home/hummingbot/certs

# Copy startup script
COPY start.sh /home/hummingbot/start.sh

# Convert line endings and set permissions
RUN dos2unix /home/hummingbot/start.sh && chmod +x /home/hummingbot/start.sh

# Install Hummingbot from source
RUN pip3 install --no-cache-dir hummingbot

# Expose port
EXPOSE 8080

# Start Hummingbot
WORKDIR /home/hummingbot
CMD ["/bin/bash", "/home/hummingbot/start.sh"]
