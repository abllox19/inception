all: start

start:
	mkdir -p /home/asoumare/data/mariadb
	mkdir -p /home/asoumare/data/wordpress
	docker compose --project-directory srcs up --build -d

stop:
	docker compose --project-directory srcs down

clean: stop
	docker compose --project-directory srcs down -v
	docker system prune -af
	sudo rm -rf /home/asoumare/data/mariadb
	sudo rm -rf /home/asoumare/data/wordpress
	mkdir -p /home/asoumare/data/mariadb
	mkdir -p /home/asoumare/data/wordpress

re: clean start

logs:
	docker compose --project-directory srcs logs -f

.PHONY: all start stop clean re logs