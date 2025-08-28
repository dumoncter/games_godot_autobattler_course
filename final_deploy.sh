#!/bin/bash
# Final deploy script for Godot Autobattler on Railway

echo "🚀 Финальный деплой Godot Autobattler на Railway"
echo "=============================================="
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
    git checkout production 2>/dev/null || git checkout -b production
fi

# Проверяем необходимые файлы
echo ""
echo "📁 Проверка файлов проекта:"
files=("Dockerfile" "project.godot" "export_presets.cfg" "nginx.conf" "railway.toml")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file найден"
    else
        echo "❌ $file отсутствует"
        exit 1
    fi
done

# Добавляем все изменения
echo ""
echo "📁 Добавляем изменения..."
git add .

# Проверяем, есть ли изменения для коммита
if [ -z "$(git status --porcelain)" ]; then
    echo "⚠️  Нет изменений для коммита"
    echo "✅ Репозиторий уже актуален"
else
    # Создаем коммит
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    COMMIT_MESSAGE="Final deploy: Godot Autobattler for Railway - $TIMESTAMP"

    echo "📝 Создаем коммит: $COMMIT_MESSAGE"
    if git commit -m "$COMMIT_MESSAGE"; then
        echo "✅ Коммит создан успешно"
    else
        echo "❌ Ошибка при создании коммита"
        exit 1
    fi
fi

# Пушим в production ветку
echo ""
echo "⬆️  Пушим в production ветку..."
if git push origin production; then
    echo "✅ Пуш выполнен успешно!"
    echo ""
    echo "🎉 ДЕПЛОЙ ЗАВЕРШЕН!"
    echo ""
    echo "📋 Railway автоматически:"
    echo "   1. Скачает и установит Godot 4.4"
    echo "   2. Соберет проект в HTML5"
    echo "   3. Настроит nginx для сервирования"
    echo "   4. Запустит игру на предоставленном URL"
    echo ""
    echo "🌐 Проверьте Railway dashboard для статуса сборки"
    echo "🎮 После успешной сборки игра будет доступна по Railway URL"
    echo ""
    echo "📊 Текущий коммит: $(git log --oneline -1)"
else
    echo "❌ Ошибка при пуше в production ветку"
    echo "💡 Возможные причины:"
    echo "   - Нет доступа к репозиторию"
    echo "   - Проблемы с аутентификацией"
    echo "   - Production ветка не существует на GitHub"
    exit 1
fi
