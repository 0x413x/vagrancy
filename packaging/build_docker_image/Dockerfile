ARG RUBY_VERSION=2.7
FROM ruby:${RUBY_VERSION}

# build-arguments used in the build context
ARG VAGRANCY_VERSION=0.0.4

RUN apt-get update -qq && apt-get -y dist-upgrade

RUN mkdir /vagrancy
WORKDIR /vagrancy

COPY Gemfile      /vagrancy/Gemfile
COPY Gemfile.lock /vagrancy/Gemfile.lock
RUN bundle install --without=development

COPY to_docker/ /vagrancy

# For testing:
# RUN bundle install --with=development
# RUN bundle exec rspec --color --format documentation spec/

RUN rm -rf spec

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
