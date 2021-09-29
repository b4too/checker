#!/bin/bash

discord="[webhook_url]"

docker ps --format "{{.Image}}" > images.list.tmp

# below will remove duplicates
uniq images.list.tmp images.list
rm -f images.list.tmp
list=""

while read line ; do

# below is needed for images such as debian/postgres/... that can only be accessed with library/[image_name] url
if [ "`echo $line | grep \/`" == "" ] ; then
  line=library/$line
fi

# belows is needed because linuxserver images will output with ghcr.io/ appended to the name and that needs to be cut
image=`echo $line | cut -d : -f 1 | sed 's/ghcr.io\///'`
tag=`echo $line | cut -d : -f 2 | sed 's/ghcr.io\///'`
last_updated=""
page=1

# below adds by default the tag 'latest' to the images that are without tag, same way docker does
if [ "$tag" == "$image" ] ; then
  tag="latest"
fi

# below is necessary because most images will get multiple pages and your tag might not be on the first
while [ "$last_updated" == "" ] ; do
repo=`curl --silent "https://hub.docker.com/v2/repositories/$image/tags?page=$page"`

# below is needed for non-docker hub images
if [ "$repo" == "{\"count\":0,\"next\":null,\"previous\":null,\"results\":[]}" ] ; then
  last_updated="1970-01-01T00:00:00.000000Z"
else
  last_updated=`echo $repo | jq --arg tag "$tag" '.results[] | select(.name==$tag) | .last_updated'`
fi
page=`expr "$page" + 1`
done

# below comparison will give as a result updates from the last 24h,
# change '86400' to another value to increase or reduce that search time
current_epoch=$(expr "$(date '+%s')" - 86400)
last_updated_epoch=$(date -d $(echo $last_updated | cut -d \" -f 2) '+%s')
if [ "$last_updated_epoch" \> "$current_epoch" ] ; then
  list=$list$(echo " and \`$line\`")
else
  echo "No update for $line since yesterday."
fi
done < images.list

text=\""An update is available for $(echo $list)"\"
curl -H "Content-Type: application/json" -d "{\"username\": \"Methatronc\",\"embeds\":[{\"description\": $text, \"title\":\"Docker Image Update Checker\", \"color\":2960895}]}" $discord
