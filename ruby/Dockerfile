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
    git \
    gnupg

# Install awslci itself
RUN pip install awscli

# Remove packages to shrink container size
RUN apk --purge -v del py-pip

RUN rm /var/cache/apk/*
# Start Docker daemon at boot
RUN rc-update add docker boot 

# Global Ruby set-up
COPY .gemrc /home/jenkins/.gemrc
RUN gem install bundler
RUN gem install foreman
RUN gem install rails

# Create a user for 'jenkins' to run as non root user
# Add group for Jenkins with UID matching box
RUN addgroup -g 116 jenkins
# Add user with UID matching box
RUN adduser -D -u 112 -G jenkins jenkins 
# Also add user to Docker group. Unneeded?
RUN adduser jenkins docker

# Create Docker metadata directory
RUN mkdir /home/jenkins/.docker
# Move sample Docker config file to directory
COPY config.json /home/jenkins/.docker

# Yarn = Add GPG key
RUN mkdir -p /opt/yarn
WORKDIR /opt/yarn
# Download Yarn
RUN wget https://yarnpkg.com/latest.tar.gz
# Add signing key
RUN wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --import
# Download signature
RUN wget https://yarnpkg.com/latest.tar.gz.asc
# Check signature
RUN gpg --verify latest.tar.gz.asc
# Extract
RUN tar zvxf latest.tar.gz
#Clean up TAR archive and sig
RUN rm latest.tar.gz*
# Split the folder name at the hyphen and take the second part as the version name
# Create a symlink to the latest version. Using the fact that the directory is the only file in this folder to create symlink
RUN ln -s $(ls) /opt/yarn/latest

# Switch to Jenkins user
USER jenkins
ENV HOME "/home/jenkins"
WORKDIR $HOME

# Add Yarn to the PATH
ENV PATH "$PATH:/opt/yarn/latest/bin"
