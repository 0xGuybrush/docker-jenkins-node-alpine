FROM 'node:current-alpine'

ENV AWSCLI_VERSION "1.14.10"
RUN apk update
# Install Docker
RUN apk add --no-cache \
	docker \
	openrc
# Install Python for AWS command line
RUN apk add --no-cache \
	python \
	py-pip
# Install awslci itself
RUN pip install awscli

# Remove packages to shrink container size
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*

# Start Docker daemon at boot
RUN rc-update add docker boot 

# Create a user for 'jenkins' to run as non root user
RUN adduser -D -u 1234 jenkins 
USER jenkins
ENV HOME "/home/jenkins"
WORKDIR $HOME

# Create Docker metadata directory
RUN mkdir ~/.docker

# Move sample Docker config file to directory
COPY config.json ~/.docker
