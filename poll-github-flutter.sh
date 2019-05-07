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

post_url=$1

git reset --hard HEAD

git fetch --tags --prune --prune-tags

git checkout master --

origin_head=$(git rev-parse @{u})
local_head=$(git rev-parse HEAD)

if [ $origin_head != $local_head ]; then
   docker_tag="latest"
   docker_tag_q="latest-q"

   eval $curl_prefix$docker_tag$curl_postfix$post_url

   sleep 1m

   eval $curl_prefix$docker_tag_q$curl_postfix$post_url

   git merge $origin_head

   sleep 5m
fi

git checkout dev --

origin_head=$(git rev-list -1 $(git describe --tags @{u}))
local_head=$(git rev-list -1 $(git describe --tags))

if [ $origin_head != $local_head ]; then
   docker_tag="dev"
   docker_tag_q="dev-q"

   eval $curl_prefix$docker_tag$curl_postfix$post_url

   sleep 1m
   
   eval $curl_prefix$docker_tag_q$curl_postfix$post_url

   git merge $origin_head

   sleep 5m
fi

git checkout beta --

origin_head=$(git rev-list -1 $(git describe --tags @{u}))
local_head=$(git rev-list -1 $(git describe --tags))

if [ $origin_head != $local_head ]; then
   docker_tag="beta"
   docker_tag_q="beta-q"

   eval $curl_prefix$docker_tag$curl_postfix$post_url

   sleep 1m
   
   eval $curl_prefix$docker_tag_q$curl_postfix$post_url

   git merge $origin_head

   sleep 5m
fi

git checkout stable --

origin_head=$(git rev-list -1 $(git describe --tags @{u}))
local_head=$(git rev-list -1 $(git describe --tags))

if [ $origin_head != $local_head ]; then
   docker_tag="stable"
   docker_tag_q="stable-q"

   eval $curl_prefix$docker_tag$curl_postfix$post_url

   sleep 1m
   
   eval $curl_prefix$docker_tag_q$curl_postfix$post_url

   git merge $origin_head

   sleep 5m
fi
