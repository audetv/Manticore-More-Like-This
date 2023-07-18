up:
	docker compose up --build -d

down:
	docker compose down --remove-orphans


docker-build:
	docker --log-level=debug build --pull --file=app/docker/production/nginx/Dockerfile --tag=${REGISTRY}/cabinet-frontend:${IMAGE_TAG} app
	docker --log-level=debug build --pull --file=app/docker/production/php-fpm/Dockerfile --tag=${REGISTRY}/cabinet-php-fpm:${IMAGE_TAG} app

localhost-build:
	REGISTRY=localhost IMAGE_TAG=0 make docker-build

docker-push:
	docker push ${REGISTRY}/cabinet-frontend:${IMAGE_TAG}
	docker push ${REGISTRY}/cabinet-php-fpm:${IMAGE_TAG}
