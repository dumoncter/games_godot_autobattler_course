# Godot Autobattler Docker Build
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Godot 4.4 (stable)
RUN wget -O godot.zip https://github.com/godotengine/godot/releases/download/4.4-stable/Godot_v4.4-stable_linux.x86_64.zip \
    && unzip godot.zip \
    && mv Godot_v4.4-stable_linux.x86_64/Godot_v4.4-stable_linux.x86_64 godot \
    && chmod +x godot \
    && rm -rf Godot_v4.4-stable_linux.x86_64 godot.zip

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app/

# Export to HTML5
RUN ./godot --export-release "HTML5" --headless

# Install nginx for serving static files
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Copy nginx config
COPY nginx.conf /etc/nginx/sites-available/default

# Create startup script
RUN echo '#!/bin/bash\n\
# Use Railway PORT or default to 80\n\
PORT=${PORT:-80}\n\
\n\
# Update nginx config to use the correct port\n\
sed -i "s/listen 80;/listen $PORT;/" /etc/nginx/sites-available/default\n\
\n\
# Start nginx\n\
nginx -g "daemon off;"' > /start.sh && chmod +x /start.sh

# Expose port (Railway will set PORT env var)
EXPOSE 80

# Start the application
CMD ["/start.sh"]
