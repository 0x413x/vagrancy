#
# Build with: docker build -t vagrancy_build --pull .
#
FROM ubuntu:14.04
RUN apt-get update -qq && apt-get -y dist-upgrade
RUN apt-get -y install curl

# Install RVM
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby

# Install Ruby 2.2.2
RUN bash -l -c "rvm requirements"
RUN bash -l -c "rvm install 2.2.2 --binary"
RUN bash -l -c "rvm use 2.2.2 --default"
RUN bash -l -c "rvm current"

# Install bundler
RUN bash -l -c "gem install bundler:1.10.6"
