all: help

up-dev: ## Start the containers in development mode
	@docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d --build

up-prod: ## Start the containers in production mode
	@docker-compose -f docker-compose.yml -f docker-compose-prod.yml up -d --build

down-dev: ## Stop the containers in development mode
	@docker-compose -f docker-compose.yml -f docker-compose-dev.yml down

down-prod: ## Stop the containers in production mode
	@docker-compose -f docker-compose.yml -f docker-compose-prod.yml down

help: ## Show this help
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  up-dev      Start the containers in development mode"
	@echo "  up-prod     Start the containers in production mode"
	@echo "  down-dev    Stop the containers in development mode"
	@echo "  down-prod   Stop the containers in production mode"
	@echo "  help        Show this help"
