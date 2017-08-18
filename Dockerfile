FROM ubuntu:latest

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV BUNDLE_PATH /bundle

# Install dependencies
RUN apt-get -y update && apt-get -y install git wget curl ruby-dev libcurl3

# Install bundler
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler

WORKDIR /app
