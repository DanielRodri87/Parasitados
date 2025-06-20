.PHONY: all setup run

all: setup run

setup:
	@echo "Enabling Linux desktop support..."
	@flutter config --enable-linux-desktop
	@flutter create --platforms=linux .

run:
	@set -a; source .env; set +a; docker compose up -d
	@flutter run -d linux
