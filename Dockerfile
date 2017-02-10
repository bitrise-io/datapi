FROM ruby:2.3.3


# ------------------------------------------------------
# --- Base pre-installed tools
RUN apt-get update -qq

# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential libpq-dev
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev


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
RUN gem install bundler --no-document && bundle install --jobs 20 --retry 5

COPY . /app
