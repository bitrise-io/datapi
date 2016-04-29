FROM ubuntu:14.04


# ------------------------------------------------------
# --- Base pre-installed tools
RUN apt-get update -qq

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential libpq-dev


# ------------------------------------------------------
# --- Pre-installed but not through apt-get

# install Ruby from source
#  from source: mainly because of GEM native extensions,
#  this is the most reliable way to use Ruby no Ubuntu if GEM native extensions are required
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
RUN wget -q http://cache.ruby-lang.org/pub/ruby/ruby-2.3.1.tar.gz
RUN tar -xvzf ruby-2.3.1.tar.gz
RUN cd ruby-2.3.1 && ./configure --prefix=/usr/local && make && make install
# cleanup
RUN rm -rf ruby-2.3.1
RUN rm ruby-2.3.1.tar.gz

RUN gem install bundler --no-document


# ------------------------------------------------------
# --- Cleanup, Workdir and revision

# Cleaning
RUN apt-get clean

# ------------------------------------------------------
# -- App
RUN mkdir /app

WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
# RUN gem install bundler --version "=1.10.0" && bundle install --jobs 20 --retry 5
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /app
