#!/bin/bash

gotify="[webhook_url]"

docker ps --format "{{.Image}}" > images.list.tmp
uniq images.list.tmp images.list
rm -f images.list.tmp
list=""

while read line ; do
if [ "`echo $line | grep \/`" == "" ] ; then
  line=library/$line
fi
image=`echo $line | cut -d : -f 1 | sed 's/ghcr.io\///'`
tag=`echo $line | cut -d : -f 2 | sed 's/ghcr.io\///'`
last_updated=""
page=1
if [ "$tag" == "$image" ] ; then
  tag="latest"
fi
while [ "$last_updated" == "" ] ; do
repo=`curl --silent "https://hub.docker.com/v2/repositories/$image/tags?page=$page"`
if [ "$repo" == "{\"count\":0,\"next\":null,\"previous\":null,\"results\":[]}" ] ; then
  last_updated="1970-01-01T00:00:00.000000Z"
else
  last_updated=`echo $repo | jq --arg tag "$tag" '.results[] | select(.name==$tag) | .last_updated'`
fi
page=`expr "$page" + 1`
done
current_epoch=$(expr "$(date '+%s')" - 86400)
last_updated_epoch=$(date -d $(echo $last_updated | cut -d \" -f 2) '+%s')
if [ "$last_updated_epoch" \> "$current_epoch" ] ; then
  list=$list$(echo "\n\`$line\`")
else
  echo "No update for $image:$tag since yesterday."
fi
done < images.list

text=\""An update is available for :$(echo $list)"\"
curl -H "Content-Type: application/json" -X POST $gotify -d "{\"title\":\"Docker Image Update Checker\",\"message\":$text,\"priority\":5,\"extras\":{\"client::display\":{\"contentType\":\"text/markdown\"}}}"
