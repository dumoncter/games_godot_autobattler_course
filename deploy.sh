#!/bin/bash
# Быстрый деплой Godot Autobattler на Railway

echo "🚀 Начинаем деплой Godot Autobattler на Railway..."
echo ""

# Настраиваем git identity если не настроена
if [ -z "$(git config user.name)" ]; then
    echo "🔧 Настраиваем Git identity..."
    git config user.name "Railway Deploy"
    git config user.email "deploy@railway.app"
    echo "✅ Git identity настроен"
fi

# Проверяем текущую ветку
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "production" ]; then
    echo "🌿 Переключаемся на production ветку..."
    git checkout production || git checkout -b production
fi

# Добавляем все изменения
echo "📁 Добавляем изменения..."
git add .

# Проверяем, есть ли изменения для коммита
if [ -z "$(git status --porcelain)" ]; then
    echo "⚠️  Нет изменений для коммита"
    echo "✅ Репозиторий уже актуален"
else
    # Создаем коммит
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    COMMIT_MESSAGE="Deploy update: $TIMESTAMP"

    echo "📝 Создаем коммит: $COMMIT_MESSAGE"
    if git commit -m "$COMMIT_MESSAGE"; then
        echo "✅ Коммит создан успешно"
    else
        echo "❌ Ошибка при создании коммита"
        exit 1
    fi
fi

# Пушим в production ветку
echo "⬆️  Пушим в production ветку..."
if git push origin production; then
    echo "✅ Пуш выполнен успешно!"
    echo ""
    echo "🎉 Деплой завершен!"
    echo ""
    echo "📋 Следующие шаги на Railway:"
    echo "   1. Перейдите в Railway dashboard"
    echo "   2. Выберите проект autobattler"
    echo "   3. Railway автоматически пересоберет с новыми файлами"
    echo "   4. Игра будет доступна по Railway URL"
    echo ""
    echo "🌐 Railway builder: Docker (не Nixpacks)"
    echo "🔧 Dockerfile: настроен для Godot 4.4"
    echo "🌐 Nginx: настроен для сервирования HTML5"
else
    echo "❌ Ошибка при пуше в production ветку"
    echo "💡 Возможные причины:"
    echo "   - Нет доступа к репозиторию"
    echo "   - Проблемы с аутентификацией"
    echo "   - Production ветка не существует на GitHub"
    exit 1
fi
