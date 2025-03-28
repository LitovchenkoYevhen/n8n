# Инструкция по настройке n8n с PostgreSQL

## Предварительные требования
- Docker и Docker Compose
- VS Code или Cursor с расширением Dev Containers
- pnpm (рекомендуется последняя версия)
- Node.js LTS версия (рекомендуется 20.x)

## Шаги по настройке

### 1. Создание файла .env
Создайте файл `.env` в корневой директории проекта со следующим содержимым:
```env
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=postgres
DB_POSTGRESDB_PASSWORD=your_secure_password_here
DB_POSTGRESDB_PORT=5432
```

### 2. Генерация безопасного пароля
Для генерации безопасного пароля выполните команду:
```bash
openssl rand -base64 32
```
Скопируйте сгенерированный пароль и вставьте его в файл `.env` в переменную `DB_POSTGRESDB_PASSWORD`.

### 3. Запуск контейнеров
Выполните следующие команды в терминале:
```bash
# Остановка существующих контейнеров
docker compose --env-file .env -f .devcontainer/docker-compose.yml down

# Запуск контейнеров с переменными окружения
docker compose --env-file .env -f .devcontainer/docker-compose.yml up -d
```

### 4. Проверка статуса контейнеров
```bash
docker compose --env-file .env -f .devcontainer/docker-compose.yml ps
```

### 5. Проверка логов
При необходимости проверьте логи:
```bash
# Логи PostgreSQL
docker compose --env-file .env -f .devcontainer/docker-compose.yml logs postgres

# Логи n8n
docker compose --env-file .env -f .devcontainer/docker-compose.yml logs n8n
```

### 6. Установка зависимостей и сборка
После успешного запуска контейнеров выполните:
```bash
# Установка зависимостей
pnpm install

# Сборка проекта
pnpm build
```

### 7. Запуск n8n
```bash
pnpm start
```

## Важные замечания
1. Файл `.env` содержит конфиденциальные данные и не должен коммититься в репозиторий
2. Файл `.env.example` служит шаблоном для других разработчиков
3. Все пароли и чувствительные данные должны храниться в переменных окружения
4. При перезапуске контейнеров всегда используйте флаг `--env-file .env`
5. При работе с Dev Containers в VS Code/Cursor, используйте команду "Dev Containers: Rebuild and Reopen in Container" для применения изменений
6. Рекомендуется использовать Node.js LTS версию для стабильной работы
7. При работе с большими объемами данных рекомендуется настроить параметры PostgreSQL в `.env`

## Устранение неполадок
1. Если контейнеры не запускаются, проверьте:
   - Существование файла `.env`
   - Правильность значений в `.env`
   - Права доступа к файлу `.env`

2. Если PostgreSQL не запускается:
   - Проверьте логи PostgreSQL
   - Убедитесь, что пароль в `.env` не пустой
   - Проверьте, что порт 5432 не занят другим процессом

3. Если n8n не может подключиться к PostgreSQL:
   - Проверьте правильность имени хоста (должно быть `postgres`)
   - Убедитесь, что все переменные окружения установлены корректно
   - Проверьте логи n8n на наличие ошибок подключения

4. Если возникают проблемы с зависимостями:
   - Удалите `node_modules` и `pnpm-lock.yaml`
   - Выполните `pnpm install` заново
   - Проверьте версию Node.js (рекомендуется LTS версия)

5. Если возникают проблемы с памятью:
   - Проверьте настройки Docker (рекомендуется минимум 4GB RAM)
   - Настройте параметры PostgreSQL для оптимизации использования памяти
   - Рассмотрите возможность использования swap-файла

## Полезные команды
```bash
# Очистка Docker
docker system prune -a

# Просмотр использования ресурсов
docker stats

# Вход в контейнер PostgreSQL
docker compose --env-file .env -f .devcontainer/docker-compose.yml exec postgres psql -U postgres

# Вход в контейнер n8n
docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh

# Проверка версии Node.js
node --version

# Проверка версии pnpm
pnpm --version
```

## Дополнительные настройки PostgreSQL
При необходимости можно добавить следующие параметры в `.env`:
```env
# Настройки пула соединений
DB_POSTGRESDB_POOL_SIZE=20
DB_POSTGRESDB_CONNECTION_TIMEOUT=20000

# Настройки SSL
DB_POSTGRESDB_SSL_ENABLED=true
DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED=true

# Настройки производительности
DB_POSTGRESDB_MAX_CONNECTIONS=100
DB_POSTGRESDB_STATEMENT_TIMEOUT=60000
```

## Резервное копирование
Для создания резервной копии базы данных:
```bash
# Создание бэкапа
docker compose --env-file .env -f .devcontainer/docker-compose.yml exec postgres pg_dump -U postgres n8n > backup.sql

# Восстановление из бэкапа
docker compose --env-file .env -f .devcontainer/docker-compose.yml exec -T postgres psql -U postgres n8n < backup.sql
```
