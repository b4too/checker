# checker
## Docker image update checker with discord/gotify webhook integration

🇫🇷 [Version Française](https://github.com/methatronc/checker/blob/main/README_FR.md) 🇫🇷

A little script that will notify you on your discord server, here is what you can expect for discord :

![discord](https://github.com/b4too/checker/assets/58328740/656ed2e0-a09b-4524-b615-2b32722ec6db)

And for gotify :

![gotify](https://user-images.githubusercontent.com/58328740/135637988-bdcd5a0e-cff5-4dd8-a036-d3ca74a1bf46.png)


For help recovering your discord webhook url see below :
<details>
  
![First](https://user-images.githubusercontent.com/58328740/134774122-ea3a12c8-13c3-42be-b93a-1d8880ecd8ec.png)
  
![Then](https://user-images.githubusercontent.com/58328740/134737215-1642581e-d109-4fcf-8c5c-0db47e28f886.png)
   
![Then](https://user-images.githubusercontent.com/58328740/134737233-01f0fa86-2766-4de8-8e75-bee694798dcb.png)
   
</details>
"Copy Webhook URL" will get you the url that needs to be put at the 3rd line of checker.sh, in the "token" variable.

If like me you would rather use gotify, see [here](https://gotify.net/docs/pushmsg) to recover the token that also needs to be put at the 3rd line of the script.

* **Installation**

   ``` bash
   sudo apt install jq curl wget
   cd && mkdir image_checker && cd image_checker
   wget https://raw.githubusercontent.com/methatronc/checker/main/checker.sh
   chmod +x checker.sh
   su [the user that will execute this cron and that MUST NOT have any special privileges since we are retrieving external data]
   crontab -e
   ```
And add the following line for instance :
   ``` bash
   0 5 * * * /home/[your_username]/image_checker/checker.sh > /home/[your_username]/image_checker/cron.log 2>&1
   ```
* Now you will have your daily report at 5am on your discord server if any image currently used on the host executing the cron gets updated.

* **Do not forget to specify the gotify/discord token at the 3rd line or else nothing will happen.**

* If you have anything to add please do, some images might need other particular treatment.
