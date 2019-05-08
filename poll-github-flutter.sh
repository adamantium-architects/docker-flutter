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

# $1 = origin head
# $2 = local head
# $3 = docker image name
function check_differences()
{
   if [ $1 != $2 ]; then
      docker_tag="$3"
      docker_tag_q="$3-q"

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

origin_head=$(git rev-parse @{u})
local_head=$(git rev-parse HEAD)

git checkout master --

check_differences $origin_head $local_head "latest"

origin_head=$(git rev-list -1 $(git describe --tags @{u}))
local_head=$(git rev-list -1 $(git describe --tags))

git checkout dev --

check_differences $origin_head $local_head "dev"

git checkout beta --

check_differences $origin_head $local_head "beta"

git checkout stable --

check_differences $origin_head $local_head "stable"
