#!/bin/sh

# Under a MIT license

# change these variables to what you need
MYSQLROOT=backup
MYSQLPASS=
GSBUCKET=bd-s1
DBFN=mysql
FILESFN=files
FILESDIR='/usr/share/nginx/html/files'
IMAGESFN=files
IMAGESDIR='/usr/share/nginx/html/images/raw'
DATABASE='--all-databases'
# the following line prefixes the backups with the defined directory. it must be blank or end with a /
GSPATH=
# when running via cron, the PATHs MIGHT be different. If you have a custom/manual MYSQL install, you should set this manually like MYSQLDUMPPATH=/usr/local/mysql/bin/
MYSQLDUMPPATH=
# Change this if your gsutil is installed somewhere different.
GSUTILPATH=
#tmp path.
TMP_PATH=~/

DATESTAMP=$(date +".%m.%d.%Y")
DAY=$(date +"%d")
DAYOFWEEK=$(date +"%A")

PERIOD=${1-day}
if [ ${PERIOD} = "auto" ]; then
  if [ ${DAY} = "01" ]; then
          PERIOD=month
  elif [ ${DAYOFWEEK} = "Sunday" ]; then
          PERIOD=week
  else
          PERIOD=day
  fi  
fi

echo "Selected period: $PERIOD."

echo "Starting backing up the database to a file..."

# dump all databases
${MYSQLDUMPPATH}mysqldump --quick --user=${MYSQLROOT} --password=${MYSQLPASS} ${DATABASE} > ${TMP_PATH}${DBFN}.sql

echo "Done backing up the database to a file."
echo "Starting compression database file..."

tar czf ${TMP_PATH}${DBFN}${DATESTAMP}.tar.gz ${TMP_PATH}${DBFN}.sql

echo "Starting compression data files..."

tar czf ${TMP_PATH}${FILESFN}${DATESTAMP}.tar.gz ${FILESDIR}

echo "Starting compression images files..."

tar czf ${TMP_PATH}${IMAGESFN}${DATESTAMP}.tar.gz ${IMAGESDIR}

echo "Done compressing the backup files."

# we want at least two backups, two months, two weeks, and two days
echo "Removing old backup (2 ${PERIOD}s ago)..."
${GSUTILPATH}gsutil rm -R gs://${GSBUCKET}/${GSPATH}previous_${PERIOD}/
echo "Old backup removed."

echo "Moving the backup from past $PERIOD to another folder..."
${GSUTILPATH}gsutil mv gs://${GSBUCKET}/${GSPATH}${PERIOD}/ gs://${GSBUCKET}/${GSPATH}previous_${PERIOD}/
echo "Past backup moved."

# upload all databases
echo "Uploading the database files..."
${GSUTILPATH}gsutil cp ${TMP_PATH}${DBFN}${DATESTAMP}.tar.gz gs://${GSBUCKET}/${GSPATH}${PERIOD}/
echo "Uploading the data files..."
${GSUTILPATH}gsutil cp ${TMP_PATH}${FILESFN}${DATESTAMP}.tar.gz gs://${GSBUCKET}/${GSPATH}${PERIOD}/
echo "Uploading the image files..."
${GSUTILPATH}gsutil cp ${TMP_PATH}${IMAGESFN}${DATESTAMP}.tar.gz gs://${GSBUCKET}/${GSPATH}${PERIOD}/
echo "New backup uploaded."

echo "Removing the cache files..."
# remove databases dump
rm ${TMP_PATH}${DBFN}.sql
rm ${TMP_PATH}${DBFN}${DATESTAMP}.tar.gz
echo "Files removed."
echo "All done."
