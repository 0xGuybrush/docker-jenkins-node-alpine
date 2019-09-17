FROM 'ruby:2.6.3-alpine3.10'

USER root
RUN apk update

# Add Chrome tags
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# cf. https://github.com/andrius/alpine-ruby
RUN apk add --no-cache \
	libxml2-dev libxslt-dev pcre-dev libffi-dev \
	postgresql-dev \
	nodejs \
	docker \
	openrc \
	python \
	py-pip \
	ruby-dev \
	postgresql-client \
	zlib-dev \
	chromium \
	xvfb \
	wait4ports \
	xorg-server \
	dbus \
	ttf-freefont \
	grep \ 
	udev \
	curl

RUN apk add --no-cache \
    build-base \
    gcc \
    wget \
    git \
    gnupg \
    tzdata \
    ghostscript \
    mesa-gles \
    mesa-egl \
    mesa-dri-swrast \
    mesa-osmesa

# cf. https://github.com/DevExpress/testcafe/issues/2116
RUN mkdir -p /usr/lib/chromium/swiftshader
RUN ln -s /usr/lib/libGLESv2.so.2 /usr/lib/chromium/swiftshader/libGLESv2.so
RUN ln -s /usr/lib/libEGL.so.1 /usr/lib/chromium/swiftshader/libEGL.so
RUN ln -s /usr/lib/libOSMesa.so.8 /usr/lib/chromium/libosmesa.so

# Install awslci itself
RUN pip install awscli
RUN pip install xunitmerge

# Remove packages to shrink container size
RUN apk --purge -v del py-pip

RUN rm /var/cache/apk/*
# Start Docker daemon at boot
RUN rc-update add docker boot 

# Global Ruby set-up
COPY .gemrc /home/jenkins/.gemrc
RUN gem install foreman
RUN gem install rails
RUN gem install bundler
RUN gem update --system '2.7.9'
RUN gem install rubocop
RUN mkdir -p /usr/local/bundle/cache/bundler/git

# Install Chrome
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

# Create a user for 'jenkins' to run as non root user
# Add group for Jenkins with UID matching box
RUN addgroup -g 116 jenkins
# Add user with UID matching box
RUN adduser -D -u 112 -G jenkins jenkins 
# Also add user to Docker group. Unneeded?
RUN adduser jenkins docker

# Give Jenkins group access to everything in Bundler folder
RUN chgrp -R jenkins /usr/local/bundle
RUN chmod -R 775 /usr/local/bundle

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
ENV BROWSER_PATH "/usr/bin/chromium-browser"
ENV PATH "$PATH:/opt/yarn/latest/bin"

# https://stackoverflow.com/a/32568666/1474421
# X Virtual Frame Buffer environment variable
ENV DISPLAY ":99"
