.PHONY: up down ps logs clean shell n8n postgres build install dev

# Запуск контейнеров
up:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml up -d

# Остановка контейнеров
down:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml down

# Просмотр статуса контейнеров
ps:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml ps

# Просмотр логов всех контейнеров
logs:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml logs -f

# Просмотр логов n8n
logs-n8n:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml logs -f n8n

# Просмотр логов postgres
logs-postgres:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml logs -f postgres

# Очистка контейнеров и томов
clean:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml down -v

# Вход в shell контейнера n8n
shell-n8n:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh

# Вход в shell контейнера postgres
shell-postgres:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec postgres sh

# Перезапуск контейнеров
restart:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml restart

# Перезапуск конкретного контейнера
restart-%:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml restart $*

# Проверка статуса базы данных
db-status:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec postgres pg_isready

# Создание резервной копии базы данных
db-backup:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec postgres pg_dump -U postgres n8n > backup_$(shell date +%Y%m%d_%H%M%S).sql

# Восстановление базы данных из резервной копии
db-restore:
	@if [ "$(file)" = "" ]; then \
		echo "Usage: make db-restore file=backup_file.sql"; \
		exit 1; \
	fi
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec -T postgres psql -U postgres n8n < $(file)

# Проверка версий
version:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml version

# Установка зависимостей
install:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm install --no-frozen-lockfile"

# Сборка проекта
build:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm build"

# Запуск в режиме разработки
dev:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm dev"

# Запуск в режиме разработки (только backend)
dev-be:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm dev:be"

# Запуск в режиме разработки (только frontend)
dev-fe:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm dev:fe"

# Запуск тестов
test:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm test"

# Запуск линтера
lint:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm lint"

# Форматирование кода
format:
	docker compose --env-file .env -f .devcontainer/docker-compose.yml exec n8n sh -c "cd /workspaces && pnpm format"

# Помощь
help:
	@echo "Доступные команды:"
	@echo "  make up           - Запуск контейнеров"
	@echo "  make down         - Остановка контейнеров"
	@echo "  make ps           - Просмотр статуса контейнеров"
	@echo "  make logs         - Просмотр логов всех контейнеров"
	@echo "  make logs-n8n     - Просмотр логов n8n"
	@echo "  make logs-postgres - Просмотр логов postgres"
	@echo "  make clean        - Очистка контейнеров и томов"
	@echo "  make shell-n8n    - Вход в shell контейнера n8n"
	@echo "  make shell-postgres - Вход в shell контейнера postgres"
	@echo "  make restart      - Перезапуск всех контейнеров"
	@echo "  make restart-n8n  - Перезапуск контейнера n8n"
	@echo "  make restart-postgres - Перезапуск контейнера postgres"
	@echo "  make db-status    - Проверка статуса базы данных"
	@echo "  make db-backup    - Создание резервной копии базы данных"
	@echo "  make db-restore file=backup.sql - Восстановление базы данных"
	@echo "  make version      - Проверка версий"
	@echo "  make install      - Установка зависимостей"
	@echo "  make build        - Сборка проекта"
	@echo "  make dev          - Запуск в режиме разработки"
	@echo "  make dev-be       - Запуск в режиме разработки (только backend)"
	@echo "  make dev-fe       - Запуск в режиме разработки (только frontend)"
	@echo "  make test         - Запуск тестов"
	@echo "  make lint         - Запуск линтера"
	@echo "  make format       - Форматирование кода"
	@echo "  make help         - Показать это сообщение"
