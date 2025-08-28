#!/bin/bash
# Настройка Git для Railway деплоя

echo "🔧 Настраиваем Git для Railway..."

# Настраиваем git identity
git config user.name "Railway Deploy"
git config user.email "deploy@railway.app"

echo "✅ Git настроен!"
echo "👤 User: $(git config user.name)"
echo "📧 Email: $(git config user.email)"

# Проверяем статус
echo ""
echo "📊 Статус репозитория:"
git status

echo ""
echo "🌿 Текущая ветка:"
git branch
