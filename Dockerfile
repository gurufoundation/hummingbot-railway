FROM hummingbot/hummingbot:latest

# Switch to root for setup
USER root

# Install curl and jq
RUN apt-get update && apt-get install -y curl jq dos2unix && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /home/hummingbot/conf /home/hummingbot/logs /home/hummingbot/data /home/hummingbot/scripts /home/hummingbot/certs

# Copy startup script
COPY start.sh /home/hummingbot/start.sh

# Convert line endings and set permissions
RUN dos2unix /home/hummingbot/start.sh && chmod +x /home/hummingbot/start.sh

# Find the actual user in the image and set ownership
RUN if id "hummingbot" &>/dev/null; then \
        chown -R hummingbot:hummingbot /home/hummingbot; \
    elif id "root" &>/dev/null; then \
        chown -R root:root /home/hummingbot; \
    fi

# Expose port
EXPOSE 8080

# Start Hummingbot as root (will switch user internally if needed)
WORKDIR /home/hummingbot
CMD ["/bin/bash", "/home/hummingbot/start.sh"]
