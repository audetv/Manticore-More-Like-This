init: down up
up:
	docker compose up --build -d

down:
	docker compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

build:
	docker --log-level=debug build --pull --file=app/docker/production/nginx/Dockerfile --tag=${REGISTRY}/cabinet-frontend:${IMAGE_TAG} app
	docker --log-level=debug build --pull --file=app/docker/production/php-fpm/Dockerfile --tag=${REGISTRY}/cabinet-php-fpm:${IMAGE_TAG} app

localhost-build:
	REGISTRY=localhost IMAGE_TAG=0 make docker-build

push:
	docker push ${REGISTRY}/cabinet-frontend:${IMAGE_TAG}
	docker push ${REGISTRY}/cabinet-php-fpm:${IMAGE_TAG}

deploy:
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'docker network create --driver=overlay traefik-public || true'
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'docker network create --driver=overlay common-library-net || true'
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'rm -rf cabinet_${BUILD_NUMBER} && mkdir cabinet_${BUILD_NUMBER}'

	envsubst < docker-compose-production.yml > docker-compose-production-env.yml
	scp -o StrictHostKeyChecking=no -P ${PORT} docker-compose-production-env.yml deploy@${HOST}:cabinet_${BUILD_NUMBER}/docker-compose.yml
	rm -f docker-compose-production-env.yml

	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'cd cabinet_${BUILD_NUMBER} && docker stack deploy --compose-file docker-compose.yml cabinet --with-registry-auth --prune'
