#!/system/bin/sh
# sy

# Functions ----------------------------------------------
MODDIR=${0%/*}
sdstatus=0
logfile=$MODDIR/data/ts-binds.log
logfileuser=/data/media/0/ts-binds.log
log="tee -a $logfile"
echo -e "Log initialised at: $(date) \n\n" > $logfile

# Copy over user's bind list ---------------------------
tsbinds update

# Barrier, do not continue until SD card is mounted ----
sleep 7
until [ $sdstatus == "1" ]; do
    if sdname=$(grep -m 1 "/mnt/media_rw/" /proc/mounts | grep -m 1 -Eo "[0-9A-Z]{4}-[0-9A-Z]{4}"); then
        sdstatus=1
        echo "sdcard $sdname mounted" | $log
    else
        sleep 1
    fi
done

# Execute ----------------------------------------------
if [ ! -f $MODDIR/data/disable ]; then
    tsbinds bind all >> $logfile 2>> $logfile
else
    echo "OFF switch file (disable.txt) found. No changes are made." | $log
fi

# End bind ---------------------------------------------
echo "Script execution completed" | $log
cp -f $logfile $logfileuser
chown 1023:1023 $logfileuser $folderlistuser $folderlist
chmod 0664 $logfileuser $folderlistuser $folderlist