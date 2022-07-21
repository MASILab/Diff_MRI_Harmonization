#!/usr/bin/bash



if [[ -z $1 ]]; then
        echo "Usage: create_dir.sh DIRECTORY_NAME"
        echo "OR"
        echo "create_dir.sh -help"      
        exit 1
elif [[ $1 == "-help" ]]; then
        echo "This script must be run from /nfs2/harmonization/BIDS/"
        echo "IT will create a directory matching the raw version without having any files"
        exit 0
fi

if [[ $PWD != "/nfs2/harmonization/BIDS" ]]; then
        echo "Error: not in /nfs2/harmonization/BIDS"
        exit 1
fi


if find /nfs2/harmonization/raw/ -maxdepth 1 -name $1; then
        echo "Raw directory found"
else
        echo "Error: no corresponding raw directory"
        exit 1
fi


RAW_DIR="/nfs2/harmonization/raw/"
BIDS_DIR="/nfs2/harmonization/BIDS/"

#echo "${BIDS_DIR}$1/database"

mkdir ${BIDS_DIR}$1

if [[ $1 == "OASIS3" ]]; then
        R_D_D_PATH="${RAW_DIR}${1}/database"
        echo $R_D_D_PATH
        ls ${R_D_D_PATH} | xargs -I II sh -c 'echo ${BIDS_DIR}$1/II'
        ls ${R_D_D_PATH} | xargs -I II sh -c 'ls -d */ ${RAW_DIR}$1/database/II | xargs -I % sh -c "echo %"'
                #for sub in ls ${BIDS_DIR}$1; do
        #       for ses in ls ${RAW_DIR}$1/database/$sub; do
        #               echo "${BIDS_DIR}$1/$sub/$ses"
        #       done
        #done
#       ls ${BIDS_DIR}$1 | xargs -I II sh -c 'echo ${BIDS_DIR}$1/II/anat echo ${BIDS_DIR}$1/II/dwi echo ${BIDS_DIR}$1/II/func '
elif [[ $1 == "ADNI" ]]; then
        ls -d *

fi
rmdir ${BIDS_DIR}$1
