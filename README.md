Backup to Google Cloud Storage
=================================
This is adapted code from: [https://github.com/woxxy/MySQL-backup-to-Amazon-S3](https://github.com/woxxy/MySQL-backup-to-Amazon-S3) and from: [https://github.com/mvarrieur/MySQL-backup-to-Google-Cloud-Storage](https://github.com/mvarrieur/MySQL-backup-to-Google-Cloud-Storage)

Only the weekly and monthly backups will backup files and images. The default settings can be used in a  GCE, CentOS, Nginx, PHP, CakePHP, Auja stack.

(This is not really an application, just a manual and some lines of code)

Setup
-----
1. Register for Google Cloud Services
2. Install gsutil [https://developers.google.com/storage/docs/gsutil_install](https://developers.google.com/storage/docs/gsutil_install)

3. Create a bucket in the [Cloud Console](https://cloud.google.com/console)
3. Configure gsutil to work with your account

		gsutil config
	
5. Put the backuptogcs.sh file somewhere in your server, like `/home/youruser`
6. Give the file 755 permissions `chmod 755 /home/youruser/backuptogcs.sh` or via FTP
7. Edit the variables near the top of the backuptogcs.sh file to match your bucket and MySQL authentication

Now we're set. You can use it manually:

	#set a new daily backup, and store the previous day as "previous_day"
	sh /home/youruser/backuptogcs.sh
	
	#set a new weekly backup, and store previous week as "previous_week"
	sh /home/youruser/backuptogcs.sh week
	
	#set a new weekly backup, and store previous month as "previous_month"
	sh /home/youruser/backuptogcs.sh month
	
But, we don't want to think about it until something breaks! So enter `crontab -e` and insert the following after editing the folders

	# daily MySQL backup to Google Cloud (not on first day of month or sundays)
	0 3 2-31 * 1-6 root sh /home/youruser/backuptogcs.sh day
	# weekly MySQL backup to Google Cloud (on sundays, but not the first day of the month)
	0 3 2-31 * 0 root sh /home/youruser/backuptogcs.sh week
	# monthly MySQL backup to Google Cloud
	0 3 1 * * root sh /home/youruser/backuptogcs.sh month

Or, if you'd prefer to have the script determine the current date and day of the week, insert the following after editing the folders

	# automatic daily / weekly / monthly backup to Google Cloud.
	0 3 * * * root sh /home/youruser/backuptogcs.sh auto

And you're set.


License
---------------

Copyright (c) 2011 FoOlRulez, Michael Varrieur, Label305 B.V.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
