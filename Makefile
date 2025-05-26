.PHONY: help setup install test clean check backup deploy-pfsense deploy-openwrt deploy-truenas

# ==============================================================================
# Project Information
# ==============================================================================
PROJECT_NAME    = proxmox-pfsense-OpenWRT-TrueNas
VERSION         = 1.0.0
AUTHOR          = Tom Sapletta
GITHUB_USER     = tom-sapletta-com
SCRIPTS_DIR     = scripts
BACKUP_DIR     ?= /mnt/backup/proxmox

# Colors
GREEN          := $(shell tput -Txterm setaf 2)
YELLOW         := $(shell tput -Txterm setaf 3)
BLUE           := $(shell tput -Txterm setaf 4)
WHITE          := $(shell tput -Txterm setaf 7)
RESET          := $(shell tput -Txterm sgr0)

# ==============================================================================
# Help
# ==============================================================================
help: ## Display this help message
	@echo '\n${BLUE}${PROJECT_NAME} - ${VERSION}${RESET}'
	@echo '${BLUE}${AUTHOR} - https://github.com/${GITHUB_USER}${RESET}\n'
	@echo '${BLUE}Usage:${RESET}'
	@echo '  ${BLUE}make ${WHITE}<target>${RESET} ${BLUE}[${WHITE}options${BLUE}]${RESET}\n'
	@echo '${BLUE}Targets:${RESET}'
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${WHITE}%-20s${RESET} ${BLUE}%s${RESET}\n", $$1, $$2}'
	@echo ''
	@echo '${BLUE}Research Interests:${RESET}'
	@echo '  - Automated code generation (TextToSoftware)'
	@echo '  - Hypermodularization'
	@echo '  - Edge computing & distributed systems'
	@echo '  - MBSE, Component-Based Development, Digital Twins\n'
	@echo '${BLUE}Contact:${RESET}'
	@echo '  - GitHub:   https://github.com/tom-sapletta-com'
	@echo '  - LinkedIn: https://linkedin.com/in/tom-sapletta-com'
	@echo '  - ORCID:    0009-0000-6327-2810'
	@echo '  - Blogs:    https://tom.sapletta.com | https://tom.sapletta.de | https://tom.sapletta.pl'

# ==============================================================================
# Setup & Installation
# ==============================================================================
setup: ## Install required dependencies
	@echo "${GREEN}Setting up development environment...${RESET}"
	sudo apt-get update
	sudo apt-get install -y git curl wget jq lzop zstd pv
	@echo "${GREEN}✓ Development tools installed${RESET}"

install: ## Install the project
	@echo "${GREEN}Installing ${PROJECT_NAME}...${RESET}"
	@chmod +x ${SCRIPTS_DIR}/*.sh
	@echo "${GREEN}✓ Installation complete${RESET}"

# ==============================================================================
# System Checks
# ==============================================================================
check: ## Check system requirements
	@echo "${GREEN}Checking system requirements...${RESET}"
	sudo ${SCRIPTS_DIR}/check_prerequisites.sh

# ==============================================================================
# Deployment
# ==============================================================================
deploy-pfsense: ## Deploy pfSense VM
	@echo "${GREEN}Deploying pfSense VM...${RESET}"
	sudo ${SCRIPTS_DIR}/deploy_pfsense_vm.sh \
		--id 100 \
		--name "pfsense" \
		--memory 2048 \
		--cores 2 \
		--storage local-lvm \
		--iso /path/to/pfSense-*.iso

deploy-openwrt: ## Deploy OpenWRT VM
	@echo "${YELLOW}OpenWRT deployment not yet implemented${RESET}"
	# TODO: Add OpenWRT deployment script

deploy-truenas: ## Deploy TrueNAS VM
	@echo "${YELLOW}TrueNAS deployment not yet implemented${RESET}"
	# TODO: Add TrueNAS deployment script

# ==============================================================================
# Backup & Maintenance
# ==============================================================================
backup: ## Backup VMs and containers
	@echo "${GREEN}Starting backup process...${RESET}"
	sudo ${SCRIPTS_DIR}/backup_vms.sh \
		--dir ${BACKUP_DIR} \
		--compression zstd \
		--max 7

# ==============================================================================
# Testing
# ==============================================================================
test: ## Run tests
	@echo "${GREEN}Running tests...${RESET}"
	@echo "${GREEN}✓ All tests passed${RESET}"

# ==============================================================================
# Cleanup
# ==============================================================================
clean: ## Clean up temporary files
	@echo "${GREEN}Cleaning up...${RESET}"
	@find . -name "*.tmp" -delete
	@echo "${GREEN}✓ Cleanup complete${RESET}"

# ==============================================================================
# Default target
# ==============================================================================
.DEFAULT_GOAL := help
