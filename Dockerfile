# Godot Autobattler Docker Build for Railway
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
    && cp Godot_v4.4-stable_linux.x86_64 /usr/local/bin/godot 2>/dev/null || \
       cp Godot_v4.4-stable_linux.x86_64/Godot_v4.4-stable_linux.x86_64 /usr/local/bin/godot 2>/dev/null || \
       find . -name "*Godot*" -type f -executable | head -1 | xargs -I {} cp {} /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm -rf godot.zip Godot_v4.4-stable_linux.x86_64*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app/

# Create build directory and export to HTML5
RUN mkdir -p /app/build/web && \
    echo "Starting Godot export..." && \
    echo "Project files:" && ls -la /app/ && \
    echo "Main scene exists:" && test -f /app/scenes/arena/arena.tscn && echo "YES" || echo "NO" && \
    /usr/local/bin/godot --export-release "HTML5" --headless && \
    echo "Godot export completed" && \
    ls -la /app/build/web/ && \
    echo "Export successful!"

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
