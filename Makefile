all: inception

inception:
	sudo mkdir -p /home/${USER}/data/mariadb
	sudo mkdir -p /home/${USER}/data/wordpress
	docker-compose -f ./srcs/requirements/docker-compose.yml up --build -d

clean:
	docker-compose -f ./srcs/requirements/docker-compose.yml down --rmi all -v --remove-orphans 2>/dev/null || true

fclean: clean
	sudo rm -rf /home/${USER}/data/*
	docker rmi -f $$(docker images -a -q) 2> /dev/null || true
	docker system prune --all --force
	docker volume prune -f

re: fclean all

.PHONY: all clean fclean re