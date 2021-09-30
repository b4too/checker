#!/bin/bash

gotify="[webhook_url]"

docker ps --format "{{.Image}}" > images.list.tmp

# la ligne suivante supprime les duplicatas
uniq images.list.tmp images.list
rm -f images.list.tmp
list=""

while read line ; do

# dessous est nécessaire pour les images telles que debian/postgres/... auxquelles on ne peut accéder que via l'url library/[nom_de_l'image]
if [ "`echo $line | grep \/`" == "" ] ; then
  line=library/$line
fi

# dessous sont nécessaires pour les images linuxserver, pour lesquelles ghcr.io/ est ajouté à chaque nom d'image
image=`echo $line | cut -d : -f 1 | sed 's/ghcr.io\///'`
tag=`echo $line | cut -d : -f 2 | sed 's/ghcr.io\///'`
last_updated=""
page=1

# dessous ajoute le tag 'latest' aux images sans tags dans votre installation, de la même façon que le fait docker
if [ "$tag" == "$image" ] ; then
  tag="latest"
fi

# boucle nécessaire car de nombreuses images auront plusieurs pages de json et le tag utilisé sur votre installation peut ne pas être sur la première
while [ "$last_updated" == "" ] ; do
repo=`curl --silent "https://hub.docker.com/v2/repositories/$image/tags?page=$page"`

# traitement nécessaire pour les images non-issues du docker hub
if [ "$repo" == "{\"count\":0,\"next\":null,\"previous\":null,\"results\":[]}" ] ; then
  last_updated="1970-01-01T00:00:00.000000Z"
else
  last_updated=`echo $repo | jq --arg tag "$tag" '.results[] | select(.name==$tag) | .last_updated'`
fi
page=`expr "$page" + 1`
done

# dessous va ressortir les mise à jour faites les dernières 24h,
# pour augmenter ou diminuer la période de recherche il faut modifier la valeur '86400' ( 24h en secondes ) 
current_epoch=$(expr "$(date '+%s')" - 86400)
last_updated_epoch=$(date -d $(echo $last_updated | cut -d \" -f 2) '+%s')
if [ "$last_updated_epoch" \> "$current_epoch" ] ; then

# deux \n sont nécessaires pour un retour à la ligne sur android
  list=$list$(echo "\n\n\`$line\`")
else
  echo "Pas de mise à jour pour $image:$tag depuis hier."
fi
done < images.list

text=\""Une mise à jour est disponible pour:$(echo $list)"\"
curl -H "Content-Type: application/json" -X POST $gotify -d "{\"title\":\"Docker Image Update Checker\",\"message\":$text,\"priority\":5,\"extras\":{\"client::display\":{\"contentType\":\"text/markdown\"}}}"
