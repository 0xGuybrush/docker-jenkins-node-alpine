FROM 'ruby:2.6.3-alpine3.10'

USER root
RUN apk update
# cf. https://github.com/andrius/alpine-ruby
RUN apk add --no-cache \
	libxml2-dev libxslt-dev pcre-dev libffi-dev \
	postgresql-dev \
	nodejs \
	docker \
	openrc \
	python \
	py-pip \
	ruby-dev

RUN apk add --no-cache \
    build-base \
    gcc \
    wget \
    git

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

COPY .gemrc /home/jenkins/.gemrc
RUN gem install bundler
RUN gem install foreman
RUN gem install rails

USER jenkins

