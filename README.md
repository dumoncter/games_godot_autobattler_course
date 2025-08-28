# Godot Autobattler Game - Railway Deploy

A singleplayer autobattler tutorial project made in Godot 4, optimized for Railway deployment.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M0RXV24)

## 🚀 Quick Deploy to Railway

### Prerequisites
- Railway account
- GitHub repository: `https://github.com/dumoncter/games_godot_autobattler_course.git`

### Deploy Steps

1. **Connect Repository to Railway**
   - Go to [Railway.app](https://railway.app)
   - Connect your GitHub repository
   - Select the `production` branch

2. **Railway will automatically:**
   - Build the Docker image using provided Dockerfile
   - Export Godot project to HTML5
   - Serve the game via Nginx

3. **Access your game:**
   - Railway will provide a URL for your deployed game
   - The game will be accessible in any web browser

## 🛠️ Local Development

### Requirements
- Godot 4.4 or later
- Docker (for testing deployment)

### Local Testing

```bash
# Test Docker build locally
docker build -t autobattler-test .

# Run locally
docker run -p 8080:80 autobattler-test

# Access at http://localhost:8080
```

### Export for Web

```bash
# Export using Godot editor or command line
godot --export-release "HTML5" --headless
```

## 📦 Deployment Script

Use the provided deployment script for easy production updates:

```bash
# Deploy with custom message
./git_push_production.sh "Updated game mechanics"

# Deploy with auto-generated message
./git_push_production.sh
```

## 🏗️ Architecture

### Files Structure
```
autobattler/
├── Dockerfile          # Docker build configuration
├── nginx.conf          # Nginx web server config
├── railway.toml        # Railway deployment config
├── export_presets.cfg  # Godot HTML5 export settings
├── git_push_production.sh # Deploy script
├── project.godot       # Godot project file
├── assets/             # Game assets
├── scenes/             # Game scenes
├── components/         # Game components
└── data/               # Game data
```

### Docker Build Process
1. Install Godot 4.4 in Ubuntu container
2. Copy project files
3. Export project to HTML5 format
4. Configure Nginx to serve static files
5. Start web server

## 🎮 Game Features

- Singleplayer autobattler gameplay
- Unit placement and strategy
- Resource management (gold, mana)
- Turn-based combat system
- Multiple unit types and abilities

### Controls
- **Left Click**: Select and place units
- **Right Click**: Cancel drag
- **S Key**: Quick sell unit
- **Q/E Keys**: Test buttons (debug)

## 🎨 Credits

- [32rogues asset pack by Seth](https://sethbb.itch.io/32rogues)
- [Kenney](https://kenney.nl/assets/cursor-pixel-pack)'s cursor pixel pack
- Sound effects are from the [Soniss GDC 2024 Game Audio Bundle](https://gdc.sonniss.com/)
- [StarNinjas](https://opengameart.org/users/starninjas) (sound effects)
- [remaxim](https://opengameart.org/users/remaxim) (sound effects)
- Music made by [Alexander Ehlers](https://opengameart.org/users/tricksntraps)
- [m5x7 font](https://managore.itch.io/m5x7) by Daniel Linssen
- [Abaddon font](https://caffinate.itch.io/abaddon) by Nathan Scott

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Note**: Check out all the branches if you're stuck. There is a different branch for each individual video tutorial.
