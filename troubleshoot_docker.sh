#!/bin/bash
# Скрипт диагностики проблем с Docker

echo "🔍 Диагностика проблем с Docker сборкой..."
echo "========================================"
echo ""

# Проверка статуса Docker
echo "1️⃣ Проверка Docker daemon..."
if docker version >/dev/null 2>&1; then
    echo "✅ Docker daemon работает"
    docker version | head -n 4
else
    echo "❌ Docker daemon не доступен"
    echo "💡 Попробуйте: sudo systemctl start docker"
    exit 1
fi

echo ""
echo "2️⃣ Проверка файлов проекта..."
if [ -f "Dockerfile" ]; then
    echo "✅ Dockerfile найден"
    echo "Размер: $(stat -c%s Dockerfile) байт"
else
    echo "❌ Dockerfile не найден"
    exit 1
fi

if [ -f "project.godot" ]; then
    echo "✅ project.godot найден"
else
    echo "❌ project.godot не найден"
fi

echo ""
echo "3️⃣ Тест базовой сборки Docker..."
cd /tmp
cat > test.dockerfile << 'EOF'
FROM ubuntu:20.04
RUN echo "Docker build test successful"
CMD ["echo", "Hello from test container"]
EOF

if docker build -f test.dockerfile -t docker-test . >/dev/null 2>&1; then
    echo "✅ Базовая сборка Docker работает"
    rm test.dockerfile
else
    echo "❌ Проблема с базовой сборкой Docker"
    echo "💡 Возможные решения:"
    echo "   - Проверьте права доступа к /tmp"
    echo "   - Перезапустите Docker: sudo systemctl restart docker"
    echo "   - Проверьте дисковое пространство: df -h"
    rm test.dockerfile
    exit 1
fi

echo ""
echo "4️⃣ Проверка доступа к директории проекта..."
cd /var/www/neonpsh.ru/games_portal/games/autobatler
if [ -r "Dockerfile" ] && [ -w "." ]; then
    echo "✅ Доступ к директории проекта OK"
else
    echo "❌ Проблемы с доступом к директории проекта"
fi

echo ""
echo "5️⃣ Рекомендации по исправлению:"
echo ""
echo "Если проблема сохраняется, попробуйте:"
echo ""
echo "а) Перезапустить Docker daemon:"
echo "   sudo systemctl restart docker"
echo ""
echo "б) Очистить Docker cache:"
echo "   docker system prune -a"
echo ""
echo "в) Проверить дисковое пространство:"
echo "   df -h"
echo ""
echo "г) Проверить права на директорию:"
echo "   ls -la /var/www/neonpsh.ru/games_portal/games/"
echo ""
echo "д) Попробовать сборку с sudo:"
echo "   sudo docker build -t autobattler-test ."
echo ""
echo "е) Если ничего не помогает, Railway может работать нормально,"
echo "   даже если локальная сборка Docker не функционирует."
