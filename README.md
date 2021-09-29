# checker
## Docker image update checker with discord/gotify webhook integration

🇫🇷 [Version Française](https://github.com/methatronc/checker/blob/main/README_FR.md) 🇫🇷

A little script that will notify you on your discord server, here is what you can expect for discord :

![discord](https://user-images.githubusercontent.com/58328740/134774138-81239fa7-1552-40fe-9a36-10981dacccad.png)

And for gotify :

![gotify](https://user-images.githubusercontent.com/58328740/135288303-b5e16f96-27e4-4fab-a3f2-bb1850bdd02c.png)

For help recovering your discord webhook url see below :
<details>
  
![First](https://user-images.githubusercontent.com/58328740/134774122-ea3a12c8-13c3-42be-b93a-1d8880ecd8ec.png)
  
![Then](https://user-images.githubusercontent.com/58328740/134737215-1642581e-d109-4fcf-8c5c-0db47e28f886.png)
   
![Then](https://user-images.githubusercontent.com/58328740/134737233-01f0fa86-2766-4de8-8e75-bee694798dcb.png)
   
</details>
"Copy Webhook URL" will get you the url that needs to be put at the 3rd line of checker_discord.sh.

For gotify, see [here](https://gotify.net/docs/pushmsg), it also needs to be put at the 3rd line in checker_gotify.sh.

* **Installation**

   ``` bash
   sudo apt install jq curl wget
   cd && mkdir image_checker && cd image_checker
   # For discord :
   wget https://raw.githubusercontent.com/methatronc/checker/main/checker_discord.sh
   # For gotify :
   wget https://raw.githubusercontent.com/methatronc/checker/main/checker_gotify.sh
   chmod +x checker_[discord/gotify].sh
   su
   crontab -e
   ```
And add the following line for instance :
   ``` bash
   0 5 * * * /home/[your_username]/image_checker/checker_[discord/gotify].sh > /home/[your_username]/image_checker/cron.log 2>&1
   ```
Now you will have your daily report at 5am on your discord server if any image currently used on the host executing the cron gets updated.


* **If you have anything to add please do, some images might need other particular treatment.**
