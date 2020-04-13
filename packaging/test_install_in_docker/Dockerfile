#
# Build with: docker build -t vagrancy_test --pull .
# Run with:   docker run --rm -n vagrancy_test -v <storage>:/var/tmp/vagrancy -p 8099:8099 vagrancy_test -h
#

# build-argument for source image version
ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}

# build-arguments used in the build context
ARG VAGRANCY_VERSION=0.0.4

RUN apt-get update -qq && apt-get -y dist-upgrade

RUN mkdir /vagrancy
WORKDIR /vagrancy

COPY vagrancy-${VAGRANCY_VERSION}-linux-x86_64.tar.gz .
RUN tar xfz vagrancy-${VAGRANCY_VERSION}-linux-x86_64.tar.gz
RUN mv vagrancy-${VAGRANCY_VERSION}-linux-x86_64 release
RUN rm -f vagrancy-${VAGRANCY_VERSION}-linux-x86_64.tar.gz

# Use default location /var/tmp/vagrancy
RUN mv release/config.sample.yml release/config.yml

WORKDIR /vagrancy/release
ENTRYPOINT ["/vagrancy/release/vagrancy"]
