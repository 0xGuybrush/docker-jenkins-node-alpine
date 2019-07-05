FROM 'node:current-alpine'
RUN apk update
RUN apk add --no-cache \
	docker \
	openrc
RUN rc-update add docker boot 

