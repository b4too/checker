# checker
## Surveillant de mise à jour d'images docker avec intégration sur serveur discord

Ce petit script va vous permettre d'être notifié sur votre serveur discord de toute mise à jour d'une image docker actuellement utilisée sur l'hôte.
Pour récupérer l'url nécessaire à l'intégration sur discord, voir ci-dessous.

<details>
  
![First](https://user-images.githubusercontent.com/58328740/134774122-ea3a12c8-13c3-42be-b93a-1d8880ecd8ec.png)
  
![Then](https://user-images.githubusercontent.com/58328740/134737215-1642581e-d109-4fcf-8c5c-0db47e28f886.png)
   
![Then](https://user-images.githubusercontent.com/58328740/134737233-01f0fa86-2766-4de8-8e75-bee694798dcb.png)
   
</details>

"Copier l'URL du Webhook" donnera le lien qu'il faut placer à la quatrième ligne du script checker_fr.sh.

* **Installation**

   ``` bash
   sudo apt install jq curl wget
   cd && mkdir image_checker && cd image_checker
   wget https://raw.githubusercontent.com/methatronc/checker/main/checker_fr.sh
   chmod +x checker.sh
   su
   crontab -e
   ```
Et ajouter la ligne suivante pour un rapport à 5h par exemple :
   ``` bash
   0 5 * * * /home/[your_username]/image_checker/checker_fr.sh > /home/[your_username]/image_checker/cron.log 2>&1
   ```
Désormais, vous aurez tous les matins à 5h un rapport vous indiquant quelles images parmis celles tournant sur votre installation docker ont été mises à jour il y a moins de 24h.
Vous pouvez vous attendre à ce visuel :

![result](https://user-images.githubusercontent.com/58328740/134774138-81239fa7-1552-40fe-9a36-10981dacccad.png)


* **Pour info**

 > la 8e ligne est pour les images telles que debian/postgres/... auxquelles on ne peut accéder que via l'url library/[nom_de_l'image]

 > sed aux 11e et 12e lignes sont nécessaires pour les images linuxserver, pour lesquelles ghcr.io/ est ajouté à chaque nom d'image

 > la 15e line ajoute le tag 'latest' aux images sans tags dans votre installation, de la même façon que fait docker

 > la boucle while à la 18e ligne est nécessaire car de nombreuses images auront plusieurs pages de json et le tag utilisé sur votre installation peut ne pas être sur la première

Si vous avez quoi que ce soit à rajouter n'hésitez pas, il est possible que certaines images nécessitent un traitement particulier comme c'est le cas par exemple pour les images linuxserver.

