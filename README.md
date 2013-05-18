mvarrieur / MySQL-backup-to-Google-Cloud-Storage
=================================
This is adapted code from: [https://github.com/woxxy/MySQL-backup-to-Amazon-S3](https://github.com/woxxy/MySQL-backup-to-Amazon-S3)

(This is not really an application, just a manual and some lines of code)

Setup
-----
1. Register for Google Cloud Services
2. Install gsutil [https://developers.google.com/storage/docs/gsutil_install](https://developers.google.com/storage/docs/gsutil_install)

3. Create a bucket in the [Cloud Console](https://cloud.google.com/console)
3. Configure gsutil to work with your account

		gsutil config
	
5. Put the mysqltogooglecloud.sh file somewhere in your server, like `/home/youruser`
6. Give the file 755 permissions `chmod 755 /home/youruser/mysqltogooglecloud.sh` or via FTP
7. Edit the variables near the top of the mysqltogooglecloud.sh file to match your bucket and MySQL authentication

Now we're set. You can use it manually:

	#set a new daily backup, and store the previous day as "previous_day"
	sh /home/youruser/mysqltogooglecloud.sh
	
	#set a new weekly backup, and store previous week as "previous_week"
	/home/youruser/mysqltogooglecloud.sh week
	
	#set a new weekly backup, and store previous month as "previous_month"
	/home/youruser/mysqltogooglecloud.sh month
	
But, we don't want to think about it until something breaks! So enter `crontab -e` and insert the following after editing the folders

	# daily MySQL backup to S3 (not on first day of month or sundays)
	0 3 2-31 * 1-6 sh /home/youruser/mysqltogooglecloud.sh day
	# weekly MySQL backup to S3 (on sundays, but not the first day of the month)
	0 3 2-31 * 0 sh /home/youruser/mysqltogooglecloud.sh week
	# monthly MySQL backup to S3
	0 3 1 * * sh /home/youruser/mysqltogooglecloud.sh month

Or, if you'd prefer to have the script determine the current date and day of the week, insert the following after editing the folders

	# automatic daily / weekly / monthly backup to S3.
	0 3 * * * sh /home/youruser/mysqltogooglecloud.sh auto

And you're set.


Troubleshooting
---------------

None yet.
