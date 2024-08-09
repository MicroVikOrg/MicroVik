start:
	make kong-postgres-kafka
kong-postgres:
	docker compose --profile database up -d
kong-postgres-kafka:
	docker compose --profile database --profile kafka_cluster up -d
clear:
	docker compose --profile database --profile kafka_cluster down --volumes
restart:
	make clear
	make start
add-kong-service:
	curl -i -X POST \
  '127.0.0.1:8001/services/' \
  --header 'Accept: */*' \
  --form 'name=${NAME}' \
  --form 'url=${URL}'

	curl -i -X POST \
  '127.0.0.1:8001/services/${NAME}/routes' \
  --header 'Accept: */*' \
  --form 'paths[]=/${NAME}'
add-kong-jwt:
	curl -i -X POST \
  '127.0.0.1:8001/services/${NAME}/plugins' \
  --header 'Accept: */*' \
  --form 'name="jwt"'