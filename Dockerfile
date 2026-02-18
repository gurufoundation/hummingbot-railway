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

# Set ownership
RUN chown -R hummingbot:hummingbot /home/hummingbot

# Switch back to hummingbot user
USER hummingbot
WORKDIR /home/hummingbot

# Expose port
EXPOSE 8080

# Start Hummingbot
CMD ["/bin/bash", "/home/hummingbot/start.sh"]
