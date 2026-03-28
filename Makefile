.PHONY: up down build logs setup seed test lint

# Start all services
up:
	cd docker && docker compose up -d --build

# Stop all services
down:
	cd docker && docker compose down

# Build without starting
build:
	cd docker && docker compose build

# View logs
logs:
	cd docker && docker compose logs -f

# Setup: migrate + seed
setup:
	cd docker && docker compose exec api bundle exec rails db:create db:migrate db:seed

# Run seeds only
seed:
	cd docker && docker compose exec api bundle exec rails db:seed

# Run backend tests
test:
	cd docker && docker compose exec api bundle exec rspec

# Run linter
lint:
	cd docker && docker compose exec api bundle exec rubocop

# Rails console
console:
	cd docker && docker compose exec api bundle exec rails console

# Run migrations
migrate:
	cd docker && docker compose exec api bundle exec rails db:migrate

# Reset database
db-reset:
	cd docker && docker compose exec api bundle exec rails db:drop db:create db:migrate db:seed
