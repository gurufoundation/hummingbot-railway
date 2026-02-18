FROM hummingbot/hummingbot:latest

# Install additional dependencies for Railway
USER root
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /home/hummingbot/conf /home/hummingbot/logs /home/hummingbot/data /home/hummingbot/scripts

# Copy configuration files
COPY conf/ /home/hummingbot/conf/
COPY scripts/ /home/hummingbot/scripts/

# Set permissions
RUN chown -R hummingbot:hummingbot /home/hummingbot

# Switch back to hummingbot user
USER hummingbot

# Set working directory
WORKDIR /home/hummingbot

# Copy startup script
COPY start.sh /home/hummingbot/start.sh
RUN chmod +x /home/hummingbot/start.sh

# Expose ports (if needed for external access)
EXPOSE 8080

# Start command
CMD ["./start.sh"]
