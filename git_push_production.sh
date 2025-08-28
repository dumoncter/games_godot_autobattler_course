#!/bin/bash
# Автоматический скрипт для коммита и пуша в ветку production
# Godot Autobattler Game - Railway Deploy Script
# Использование: ./git_push_production.sh [сообщение коммита]

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для управления backup ветками
manage_backup_branches() {
    echo -e "${BLUE}🔍 Ищем существующие backup ветки...${NC}"

    # Получаем список всех backup веток с датами создания
    BACKUP_BRANCHES=$(git for-each-ref --format='%(refname:short) %(creatordate:short)' refs/heads/backup-* | sort -k2,2r | awk '{print $1}')

    if [ -z "$BACKUP_BRANCHES" ]; then
        echo -e "${YELLOW}📭 Backup веток не найдено${NC}"
        return
    fi

    # Подсчитываем количество backup веток
    BRANCH_COUNT=$(echo "$BACKUP_BRANCHES" | wc -l)
    echo -e "${BLUE}📊 Найдено backup веток: $BRANCH_COUNT${NC}"

    # Показываем все backup ветки с датами
    echo -e "${BLUE}📋 Текущие backup ветки (от новых к старым):${NC}"
    echo "$BACKUP_BRANCHES" | nl -w2 -s") "

    # Если веток больше 5, удаляем старые
    if [ "$BRANCH_COUNT" -gt 5 ]; then
        echo -e "${YELLOW}🗑️  Удаляем старые backup ветки (оставляем последние 5)...${NC}"

        # Получаем список веток для удаления (все кроме первых 5)
        BRANCHES_TO_DELETE=$(echo "$BACKUP_BRANCHES" | tail -n +6)

        for branch in $BRANCHES_TO_DELETE; do
            echo -e "${YELLOW}   Удаляем локальную ветку: $branch${NC}"
            git branch -D "$branch" 2>/dev/null || echo -e "${RED}   ⚠️  Не удалось удалить локальную ветку: $branch${NC}"

            echo -e "${YELLOW}   Удаляем удаленную ветку: origin/$branch${NC}"
            git push origin --delete "$branch" 2>/dev/null || echo -e "${RED}   ⚠️  Не удалось удалить удаленную ветку: $branch${NC}"
        done

        echo -e "${GREEN}✅ Старые backup ветки удалены${NC}"
    else
        echo -e "${GREEN}✅ Все backup ветки актуальны (не более 5)${NC}"
    fi

    # Показываем оставшиеся backup ветки
    REMAINING_BACKUPS=$(git branch --list "backup-*" | wc -l)
    echo -e "${BLUE}📦 Осталось backup веток: $REMAINING_BACKUPS${NC}"

    if [ "$REMAINING_BACKUPS" -gt 0 ]; then
        echo -e "${BLUE}📋 Список оставшихся backup веток:${NC}"
        git for-each-ref --format='%(refname:short) %(creatordate:short)' refs/heads/backup-* | sort -k2,2r | nl -w2 -s") "
    fi
}

echo -e "${GREEN}🚀 Godot Autobattler - Начинаем автоматический коммит и пуш в production ветку${NC}"

# Проверяем, есть ли изменения для коммита
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  Нет изменений для коммита${NC}"
    echo -e "${GREEN}✅ Репозиторий уже актуален${NC}"
    exit 0
fi

# Добавляем все изменения
echo "📁 Добавляем все изменения..."
git add .

# Создаем сообщение коммита
if [ -n "$1" ]; then
    COMMIT_MESSAGE="$1"
else
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    COMMIT_MESSAGE="Auto-deploy Autobattler: $TIMESTAMP"
fi

# Делаем коммит
echo "📝 Создаем коммит с сообщением: '$COMMIT_MESSAGE'"
if git commit -m "$COMMIT_MESSAGE"; then
    echo -e "${GREEN}✅ Коммит успешно создан${NC}"
else
    echo -e "${RED}❌ Ошибка при создании коммита${NC}"
    exit 1
fi

# Пушим в production ветку
echo "⬆️  Пушим изменения в ветку production..."
if git push origin production; then
    echo -e "${GREEN}✅ Успешно запушено в production ветку${NC}"

    # Создаем backup ветку для текущего коммита
    BACKUP_BRANCH_NAME="backup-$(date +%Y%m%d_%H%M%S)"
    echo "💾 Создаем backup ветку: $BACKUP_BRANCH_NAME"
    if git checkout -b "$BACKUP_BRANCH_NAME"; then
        echo -e "${GREEN}✅ Backup ветка создана: $BACKUP_BRANCH_NAME${NC}"
        git checkout production
        # Запоминаем имя созданной backup ветки для вывода в конце
        CREATED_BACKUP_BRANCH="$BACKUP_BRANCH_NAME"
    else
        echo -e "${RED}❌ Ошибка при создании backup ветки${NC}"
        CREATED_BACKUP_BRANCH=""
    fi

    echo -e "${GREEN}🔗 Production ветка обновлена!${NC}"
    echo -e "${GREEN}🎮 Godot Autobattler готов к развертыванию на Railway${NC}"

    # Управление backup ветками - оставляем только последние 5
    echo "🧹 Управляем backup ветками..."
    manage_backup_branches
else
    echo -e "${RED}❌ Ошибка при пуше в production ветку${NC}"
    echo -e "${YELLOW}💡 Возможно, нужно сначала сделать pull:${NC}"
    echo "   git pull origin production"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Все операции выполнены успешно!${NC}"
echo "📊 Статус: $(git log --oneline -1)"

# Показываем информацию о backup ветке, если она была создана
if [ -n "$CREATED_BACKUP_BRANCH" ]; then
    echo ""
    echo -e "${BLUE}💾 BACKUP ИНФОРМАЦИЯ:${NC}"
    echo -e "${BLUE}  📦 Создана backup ветка: ${CREATED_BACKUP_BRANCH}${NC}"
    echo -e "${BLUE}  🔄 Для восстановления: git checkout ${CREATED_BACKUP_BRANCH}${NC}"
    echo -e "${BLUE}  ⚠️  Всего хранится не более 5 последних backup веток${NC}"
fi

echo ""
echo -e "${GREEN}🌐 Railway Deploy Info:${NC}"
echo -e "${BLUE}  🔧 Dockerfile настроен для Godot 4.4${NC}"
echo -e "${BLUE}  🌐 Nginx настроен для сервирования HTML5 экспорта${NC}"
echo -e "${BLUE}  📦 Railway.toml настроен для автоматического деплоя${NC}"
echo -e "${BLUE}  🎯 Игра будет доступна по URL Railway сервиса${NC}"
