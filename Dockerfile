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

# Add group for Jenkins with UID matching box
RUN addgroup -g 116 jenkins
# Add user with UID matching box
RUN adduser -D -u 112 -G jenkins jenkins 

# Also add user to Docker group. Unneeded?
RUN adduser jenkins docker
USER jenkins
ENV HOME "/home/jenkins"
WORKDIR $HOME

# Create Docker metadata directory
RUN mkdir ~/.docker

# Move sample Docker config file to directory
COPY config.json ~/.docker
