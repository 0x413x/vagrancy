#!/bin/bash -e
#
# Test and build vagrancy.
#

cd /vagrancy
bundle install --with=development

# Test
bundle exec rspec --color --format documentation spec/

# Package
rake package

chown ${TARGET_USER_ID}:${TARGET_GROUP_ID} *.tar.gz
