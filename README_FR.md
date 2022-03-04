# checker
## Surveillant de mise à jour d'images docker avec intégration sur serveur discord/gotify

Ce petit script va vous permettre d'être notifié sur votre serveur discord ou gotify de toute mise à jour d'une image docker actuellement utilisée sur l'hôte.

Vous pouvez vous attendre à ceci sur discord :

![discord](https://user-images.githubusercontent.com/58328740/135635968-d73e27e8-2bcf-458d-959e-a4a82d1f994d.png)


Et à ceci sur gotify :

![gotify](https://user-images.githubusercontent.com/58328740/135636875-5e8f9611-6797-4e63-b70f-c5c16285999e.png)


Pour récupérer l'url nécessaire à l'intégration sur discord, voir ci-dessous.

<details>
  
![First](https://user-images.githubusercontent.com/58328740/134774122-ea3a12c8-13c3-42be-b93a-1d8880ecd8ec.png)
  
![Then](https://user-images.githubusercontent.com/58328740/134737215-1642581e-d109-4fcf-8c5c-0db47e28f886.png)
   
![Then](https://user-images.githubusercontent.com/58328740/134737233-01f0fa86-2766-4de8-8e75-bee694798dcb.png)
   
</details>

"Copier l'URL du Webhook" donnera le lien qu'il faut placer à la troisième ligne du script checker.sh dans la variable "token".

De même, il faudra placer à ce même endroit l'url de votre serveur gotify avec le token dans la variable "token" si c'est comme moi la solution que vous préférez.

Pour savoir comment faire pour récupérer l'url+token de gotify [rendez-vous ici](https://gotify.net/docs/pushmsg).

* **Installation**

   ``` bash
   sudo apt install jq curl wget
   cd && mkdir image_checker && cd image_checker
   wget https://raw.githubusercontent.com/methatronc/checker/main/checker.sh
   chmod +x checker.sh
   su [utilisateur qui va executer ce script et qui ne DOIT PAS avoir le moindre privilège superflu car nous traitons des données externes]
   crontab -e
   ```
Et ajouter la ligne suivante pour un rapport à 5h par exemple :
   ``` bash
   0 5 * * * /home/[your_username]/image_checker/checker.sh > /home/[your_username]/image_checker/cron.log 2>&1
   ```
* Désormais, vous aurez tous les matins à 5h un rapport vous indiquant quelles images parmis celles tournant sur votre installation docker ont été mises à jour il y a moins de 24h.

* **N'oubliez pas de mettre dans le script votre token gotify ou discord, sans cela ce script n'aura aucun effet.**

* Si vous avez quoi que ce soit à rajouter n'hésitez pas, il est possible que certaines images nécessitent un traitement particulier comme c'est le cas par exemple pour les images linuxserver.
