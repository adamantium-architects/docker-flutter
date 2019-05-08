#!/bin/bash

# Execute this script such that $(pwd) returns the top level of a
# flutter git workspace. This script will mantain a clean repository.
#
# If the need to kick off a triggered build is identified, the script
# will sleep for 5 minutes to avoid tripping Docker's build rate limiter.

curl_prefix="curl -H \"Content-Type: application/json\" --data '{\"docker_tag\": \""
curl_postfix="\"}' "

if [ $# == 0 ]; then
   echo "Docker trigger URL required as input parameter."

   exit 1
fi

# $1 = docker image name
function check_differences()
{
   if [ "$1" == "latest" ]; then
      git checkout master --

      origin_head=$(git rev-parse @{u})
      local_head=$(git rev-parse HEAD)
   else
      git checkout $1 --

      origin_head=$(git rev-list -1 $(git describe --tags @{u}))
      local_head=$(git rev-list -1 $(git describe --tags))
   fi

   if [ $origin_head != $local_head ]; then
      docker_tag="$1"
      docker_tag_q="$1-q"

      eval $curl_prefix$docker_tag$curl_postfix$post_url

      sleep 1m

      eval $curl_prefix$docker_tag_q$curl_postfix$post_url

      git merge $origin_head

      sleep 5m
   fi
}

post_url=$1

git reset --hard HEAD

git fetch --tags --prune --prune-tags

check_differences "latest"

check_differences "dev"

check_differences "beta"

check_differences "stable"
