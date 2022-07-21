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

#makes the new directory
mkdir ${BIDS_DIR}$1

#for OASIS3
if [[ $1 == "OASIS3" ]]; then
	R_D_D_PATH="${RAW_DIR}${1}/database/" #path to raw subject directories
#create all subject directories and session directories
#WORKS
	find ${R_D_D_PATH} -maxdepth 2 -mindepth 1 -type d | awk -F '/' '{print $7 "/" $8}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/II'
#create all sub-session directories
#WORKS
	find ${R_D_D_PATH} -maxdepth 3 -mindepth 3 -type d | awk -F '/' '{print $7 "/" $8 "/" $9}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/II'

#for ADNI
elif [[ $1 == "ADNI" ]]; then
	R_D_PATH="${RAW_DIR}${1}/"

#creates all subject directories
	find ${R_D_PATH} -maxdepth 1 -mindepth 1 -type d | awk -F '/' '{print $6}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/II'
#creates all session directories
	find ${R_D_PATH} -maxdepth 2 -mindepth 2 -type d | awk -F '/' '{print $6 "/ses-" $7}' | awk -F '_' '{print $1 "-" $2}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/II' 
#creates all sub-session directories
	find ${R_D_PATH} -maxdepth 2 -mindepth 2 -type d | awk -F '/' '{print $6 "/ses-" $7}' | awk -F '_' '{print $1 "-" $2}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/II/dwi '$BIDS_DIR$1'/II/anat'


fi
rmdir ${BIDS_DIR}$1





