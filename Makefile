start:
	docker compose up -d
	sleep 20
	make cockroach-configure
	make kong-configure
check:
	docker compose up -d
clear:
	docker compose down --volumes
restart:
	make clear
	make start
kong-configure:
	curl -i -X POST http://127.0.0.1:8001/plugins \
		--data "name=proxy-cache" \
		--data "config.request_method=GET" \
		--data "config.response_code=200" \
		--data "config.content_type=application/json" \
		--data "config.cache_ttl=30" \
		--data "config.strategy=memory"
	make kong-upstreams-configure
kong-upstreams-configure:
	curl -X POST http://localhost:8001/upstreams --data name=usermanager_upstream
	curl -X POST http://localhost:8001/upstreams --data name=chatmanager_upstream
	curl -X POST http://localhost:8001/upstreams --data name=msgmanager_upstream
	curl -i -X POST 127.0.0.1:8001/upstreams/usermanager_upstream/targets \
		--form 'target="usermanager:8080"'
	curl -i -X POST 127.0.0.1:8001/upstreams/chatmanager_upstream/targets \
		--form 'target="chatmanager:8080"'
	curl -i -X POST 127.0.0.1:8001/upstreams/msgmanager_upstream/targets \
		--form 'target="messagesmanager:8080"'
	make add-kong-service NAME=usermanager HOST=usermanager_upstream
	make add-kong-service NAME=chatmanager HOST=chatmanager_upstream
	make add-kong-service NAME=msgmanager HOST=msgmanager_upstream
cockroach-configure:
	docker exec -it roach-node bash /setup_db.sh
add-kong-service:
	curl -i -X POST 127.0.0.1:8001/services/ \
		--form 'name=${NAME}' \
		--form 'host="${HOST}"'
	curl -i -X POST 127.0.0.1:8001/services/${NAME}/routes/ --form paths[]="/${NAME}"
add-kong-jwt:
	curl -i -X POST 127.0.0.1:8001/services/${NAME}/plugins --form 'name="jwt"'