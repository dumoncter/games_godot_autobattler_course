#!/bin/bash
# Quick test without Docker build

echo "🔍 Быстрая проверка проекта Autobattler..."
echo "==========================================="
echo ""

# Check required files
echo "📁 Проверка файлов проекта:"
echo ""

if [ -f "Dockerfile" ]; then
    echo "✅ Dockerfile найден"
    echo "   Размер: $(stat -c%s Dockerfile) байт"
else
    echo "❌ Dockerfile отсутствует"
fi

if [ -f "project.godot" ]; then
    echo "✅ project.godot найден"
else
    echo "❌ project.godot отсутствует"
fi

if [ -f "export_presets.cfg" ]; then
    echo "✅ export_presets.cfg найден"
else
    echo "❌ export_presets.cfg отсутствует"
fi

if [ -f "nginx.conf" ]; then
    echo "✅ nginx.conf найден"
else
    echo "❌ nginx.conf отсутствует"
fi

if [ -f "railway.toml" ]; then
    echo "✅ railway.toml найден"
else
    echo "❌ railway.toml отсутствует"
fi

echo ""
echo "📊 Структура проекта:"
ls -la | grep -E '\.(gd|cfg|toml|conf|sh)$'

echo ""
echo "🎯 Для деплоя на Railway:"
echo "1. Запушь все файлы в репозиторий:"
echo "   ./deploy.sh"
echo ""
echo "2. Railway автоматически:"
echo "   - Скачает Godot"
echo "   - Соберет проект в HTML5"
echo "   - Запустит nginx сервер"
echo ""
echo "3. Игра будет доступна по Railway URL"

echo ""
echo "⚡ Быстрый тест Docker (без Godot):"
echo "docker build -f Dockerfile.fast -t test . && docker run -p 8000:8000 test"
