
docker-clean:
	docker container prune -f
	docker image prune -f


docker-build: docker-clean
	docker image build .

docker-up:
	docker-compose up

docker-up-build:
	docker-compose up --build

docker-down:
	docker-compose down

docker-down-volumes:
	docker-compose down --volumes

docker-down-all:
	docker-compose down --rmi all
