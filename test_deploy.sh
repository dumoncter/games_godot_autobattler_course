#!/bin/bash
# Тестовый скрипт для проверки настройки Railway деплоя

echo "🧪 Тестируем настройку Railway деплоя для Godot Autobattler..."
echo ""

# Настраиваем git identity
echo "1️⃣ Настраиваем Git identity..."
git config user.name "Railway Deploy"
git config user.email "deploy@railway.app"
echo "✅ Git identity настроен"

# Проверяем статус
echo ""
echo "2️⃣ Проверяем статус репозитория..."
echo "Текущая ветка: $(git branch --show-current)"
echo "Remote origin: $(git remote get-url origin)"

# Проверяем, есть ли изменения
if [ -z "$(git status --porcelain)" ]; then
    echo "⚠️  Нет изменений для коммита"
else
    echo "📝 Есть изменения для коммита"
    git status --short
fi

echo ""
echo "3️⃣ Тестируем коммит..."
if git commit -m "Test commit for Railway deploy setup"; then
    echo "✅ Коммит создан успешно!"
else
    echo "❌ Ошибка при создании коммита"
    exit 1
fi

echo ""
echo "4️⃣ Тестируем пуш в production..."
if git push origin production; then
    echo "✅ Пуш в production ветку выполнен успешно!"
    echo ""
    echo "🎉 Все тесты пройдены! Проект готов к деплою на Railway."
    echo ""
    echo "📋 Следующие шаги:"
    echo "   1. Подключите репозиторий к Railway"
    echo "   2. Выберите production ветку"
    echo "   3. Railway автоматически развернет игру"
else
    echo "❌ Ошибка при пуше в production ветку"
    echo "💡 Возможные причины:"
    echo "   - Нет доступа к репозиторию"
    echo "   - Production ветка не существует на GitHub"
    echo "   - Проблемы с аутентификацией"
fi
