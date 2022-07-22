#!/usr/bin/bash


if [[ -z $1 ]]; then
        echo "Usage: create_sims.sh DIRECTORY_NAME"
        echo "OR"
        echo "create_sims.sh -help"
        exit 1
elif [[ $1 == "-help" ]]; then
        echo "This script must be run from /nfs2/harmonization/BIDS/"
        echo "It will create a directory matching the raw version without having any files"
        exit 0
fi

if [[ $PWD != "/nfs2/harmonization/BIDS" ]]; then
        echo "Error: not currently in /nfs2/harmonization/BIDS"
        exit 1
fi


if find /nfs2/harmonization/raw/ -maxdepth 1 -name $1; then
        echo "Raw directory found"
else
        echo "Error: no corresponding raw directory"
        exit 1
fi

if find /nfs2/harmonization/BIDS/ -maxdepth 1 -name $1; then
        echo "BIDS directory found"
else
        echo "Error: BIDS directory not found for: $1"
fi


RAW_DIR="/nfs2/harmonization/raw/"
BIDS_DIR="/nfs2/harmonization/BIDS/"

if [[ $1 == "ADNI" ]]; then
        R_D_PATH="${RAW_DIR}${1}/"
        B_D_PATH="${BIDS_DIR}${1}/"
#too much change btw directory names to make the linking easy
        #either change them back to OG or find a way to sort out where links should go through good parsing of strings
        find ${R_D_PATH} -maxdepth 3 -mindepth 3 -type f | head -n 2 | xargs -I II sed 's/'


fi

#for OASIS3
if [[ $1 == "OASIS3" ]]; then
        R_D_PATH="${RAW_DIR}${1}/database/"
        B_D_PATH="${BIDS_DIR}${1}/"

#first do the dataset_description.json files
        #WORKS
        find ${R_D_PATH} -maxdepth 3 -mindepth 3 -type f | head -n 1 | awk -F '/' '{print $7 "/" $8 "/" $9}' | xargs -I II sh -c 'ln -s '$R_D_PATH'II '$B_D_PATH'II'

#next, do all the anat, dwi, fmap, func files
        #WORKS
        find ${R_D_PATH} -maxdepth 4 -mindepth 4 -type f | head -n 1 | awk -F '/' '{print $7 "/" $8 "/" $9 "/" $10}' | xargs -I II sh -c 'ln -s '$R_D_PATH'II '$B_D_PATH'II'



fi



