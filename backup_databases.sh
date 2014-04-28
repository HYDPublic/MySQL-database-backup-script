# Script to back up MySQL databases
# Made by Zachoz
 
# Databases to backup, seperated by a ' ' (space)
declare -a databases=(some_database another_database)
 
# Directory to store backup files in
backupdir=backups/
 
# MySQL login details
mysql_user="root"
mysql_password="password"
 
# Internal variables - do not change!
hdateformat=$(date '+%Y-%m-%d-%H-%M-%S')H$ext
numdbs=${#databases[@]}
 
echo "Starting database backup!"

cd "`dirname "$0"`" # Move into the directory that the script is in
 
# Create backups directory if it doesn't exist
if [ -d $backupdir ] ; then
    sleep 0
else
    mkdir -p $backupdir
fi
 
# Make temp directories
mkdir backups-$hdateformat
cd backups-$hdateformat
 
# Dump databases
echo "Dumping databases..."
for ((i=0;i<$numdbs;i++)); do
    mysqldump -u $mysql_user -p$mysql_password ${databases[$i]} > ${databases[$i]}.sql
    echo "Dumped database: '${databases[$i]}'"
done
 
# Zip database dump files
echo "Zipping database dump files..."
for ((i=0;i<$numdbs;i++)); do
    zip -9r ${databases[$i]}.sql.zip ${databases[$i]}.sql
    rm -rf ${databases[$i]}.sql
    echo "Zipped database: '${databases[$i]}'"
done
 
cd ..
 
# Delete file if one already exists under the same name
if [ -d backups-$hdateformat.zip ] ; then
    sleep 0
else
    rm -rf backups-$hdateformat.zip
    echo "Removed old backup with the same file name!"
fi
 
# Zip all the files together
zip -9r backups-$hdateformat.zip backups-$hdateformat
 
# Move them to the backup directory
mv backups-$hdateformat.zip $backupdir/backups-$hdateformat.zip
 
echo "Cleaning up...."
 
# Remove temp files
rm -rf backups-$hdateformat
 
echo "Done!"
