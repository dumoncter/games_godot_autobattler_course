#!/bin/bash
# Тестовый скрипт для проверки Docker сборки локально

echo "🧪 Тестирование Docker сборки для Godot Autobattler..."
echo ""

# Остановить и удалить предыдущий контейнер если существует
echo "1️⃣ Очистка предыдущих контейнеров..."
docker stop autobattler-test 2>/dev/null || true
docker rm autobattler-test 2>/dev/null || true

# Сборка образа
echo ""
echo "2️⃣ Сборка Docker образа..."
if docker build -t autobattler-test .; then
    echo "✅ Сборка образа успешна!"
else
    echo "❌ Ошибка при сборке образа"
    exit 1
fi

# Запуск контейнера
echo ""
echo "3️⃣ Запуск контейнера..."
if docker run -d --name autobattler-test -p 8080:80 autobattler-test; then
    echo "✅ Контейнер запущен!"
    echo ""
    echo "🌐 Доступ к игре: http://localhost:8080"
    echo ""
    echo "📊 Проверка логов контейнера:"
    sleep 3
    docker logs autobattler-test
    echo ""
    echo "🛑 Для остановки: docker stop autobattler-test"
    echo "🧹 Для очистки: docker rm autobattler-test"
else
    echo "❌ Ошибка при запуске контейнера"
    echo ""
    echo "📊 Логи сборки:"
    docker logs autobattler-test 2>/dev/null || echo "Нет логов доступно"
    exit 1
fi
