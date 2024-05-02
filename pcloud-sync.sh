#!/bin/bash
# Tom Akkermans' home backup script with sync to pCloudDrive
# Version 1.0

# if given argument 1, the changes are implemented for real (be careful!)
REAL=0
REAL=$1

FILESIZELIMIT=100000   #file size limit in megabytes

#layout colors:
BRed='\033[1;31m' # Red
Color_Off='\033[0m'

printf "${BRed}Starting backup program.. [backup-tomakker-home]${Color_Off}\n"

START_TIME=$SECONDS

INPUTDIR="/media/tom/EXTERNE/" #the list of source directories is considered RELATIVE to this main input directory (!!)
LIST_INPUTSUBDIRS="/media/tom/EXTERNE/Documenten/Scripts/pcloud-sync/pcloud-sync-sourcedirs.txt"   # relative paths of subdirectories, one per line; start and end each relative subdirectory with '/'
LIST_EXCLUSIONPATTERNS="/media/tom/EXTERNE/Documenten/Scripts/pcloud-sync/pcloud-sync-exclude.txt" # filename patterns to exclude, one pattern per line, e.g. exclude hidden files with pattern .*
OUTPUTDIR="/home/tom/pCloudDrive/"  #local or remote output directory; fix private key for remote in order to avoid password prompts



echo "checking backup directories for changes.."

CHANGES=$(rsync -nari --delete --max-size=${FILESIZELIMIT}m --files-from=${LIST_INPUTSUBDIRS} --exclude-from=${LIST_EXCLUSIONPATTERNS} ${INPUTDIR} ${OUTPUTDIR} | egrep '^>|^*deleting')

if [ "${CHANGES}" != "" ]; then
    echo "following additions (>) and/or deletions (*) will be implemented:"
    echo "$CHANGES"
fi


if [ "$REAL" = "1" ]; then
    rsync -avrq --delete --max-size=${FILESIZELIMIT}m --files-from=${LIST_INPUTSUBDIRS} --exclude-from=${LIST_EXCLUSIONPATTERNS} ${INPUTDIR} ${OUTPUTDIR}
fi

ELAPSED_TIME=$(($SECONDS - $START_TIME))
printf "${BRed}Finished... [$(($ELAPSED_TIME / 60))min.$(($ELAPSED_TIME % 60))sec. elapsed]${Color_Off}\n"
