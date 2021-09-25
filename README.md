# checker
## Docker image updatechecker with discord webhook

A little script that will notify you on your discord server, check below if needed.
<details>
  
![First](https://user-images.githubusercontent.com/58328740/134774122-ea3a12c8-13c3-42be-b93a-1d8880ecd8ec.png)
  
![Then](https://user-images.githubusercontent.com/58328740/134737215-1642581e-d109-4fcf-8c5c-0db47e28f886.png)
   
![Then](https://user-images.githubusercontent.com/58328740/134737233-01f0fa86-2766-4de8-8e75-bee694798dcb.png)
   
</details>
"Copy Webhook URL" will get you the url that needs to be put at the 4th line of checker.sh.

* **Installation**

   ``` bash
   sudo apt install jq curl wget
   cd && mkdir image_checker && cd image_checker
   wget https://raw.githubusercontent.com/methatronc/checker/main/checker.sh
   chmod +x checker.sh
   su
   crontab -e
   ```
And add the following line for instance :
   ``` bash
   0 5 * * * /home/[your_username]/image_checker/checker.sh > /home/[your_username]/image_checker/cron.log 2>&1
   ```
Now you will have your daily report at 5am on your discord server if any image currently used on the host executing the cron gets updated.
Here is what you can expect :

![result](https://user-images.githubusercontent.com/58328740/134774138-81239fa7-1552-40fe-9a36-10981dacccad.png)


* **For info**

 > 8th line is for images such as debian/postgres/... that can only be accessed with library/[image_name] url

 > sed at 11th and 12th lines is used because linuxserver images will output with ghcr.io/ appended to the name and that needs to be cut

 > the 15th line adds by default the tag 'latest' to the images that are without tag, same way docker does

 > the 18th line while loop is necessary because most images will get multiple pages and your tag might not be on the first

If you have anything to add please do, some images might need other particular treatment.

