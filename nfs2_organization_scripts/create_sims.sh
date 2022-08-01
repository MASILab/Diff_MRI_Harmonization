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
	#find ${R_D_PATH} -maxdepth 3 -mindepth 3 -type f | head -n 2  | awk -F '/' '{print $6 "/" $7 "/" $8}' | ${BIDS_DIR}ADNI_FR_Help.sh
#all the MPRAGE files in adni3
	find ${R_D_PATH} -type f -iname "*MPRAGE*" | grep -i "adni3" | awk -F '/' '{print "ln -s "$0" /nfs2/harmonization/BIDS/ADNI/"$6"/"$7"/anat/"$6"_"$7}' | sed 's/adni3_/ses-adni3-/g'
#all the SPRG files in adni2
	find ${R_D_PATH} -type f -iname "*SPGR*" | grep -i "adni2" | awk -F '/' '{print "ln -s "$0" /nfs2/harmonization/BIDS/ADNI/"$6"/ses-adni2-baseline/anat/"$8}'
#all the MPRAGE files in adnigo	
	find ${R_D_PATH} -type f -iname "*MPRAGE*" | grep -i "adnigo" | awk -F '/' '{print "ln -s "$0" /nfs2/harmonization/BIDS/ADNI/"$6"/ses-adnigo-baseline/anat/"$8}'
#all the MPRAGE files in adni2
	find ${R_D_PATH} -type f -iname "*MPRAGE*" | grep -i "adni2" | awk -F '/' '{print "ln -s "$0" /nfs2/harmonization/BIDS/ADNI/"$6"/ses-adni2-baseline/anat/"$8}'
#all the SPGR files in adni3
	find ${R_D_PATH} -type f -iname "*SPGR*" | grep -i "adni3" | awk -F '/' '{print "ln -s "$0" /nfs2/harmonization/BIDS/ADNI/"$6"/ses-adni3-baseline/anat/"$8}'
#all the SPGR files in adnigo
	find ${R_D_PATH} -type f -iname "*SPGR*" | grep -i "adnigo" | awk -F '/' '{print "ln -s "$0" /nfs2/harmonization/BIDS/ADNI/"$6"/ses-adnigo-baseline/anat/"$8}'
fi

#for OASIS3
if [[ $1 == "OASIS3" ]]; then
	R_D_PATH="${RAW_DIR}${1}/database/"
	B_D_PATH="${BIDS_DIR}${1}/"

#first do the dataset_description.json files
	#WORKS: idea was to get the whole rest of the path (which is the same) with awk and then use that to create OG and symlink paths
	find ${R_D_PATH} -maxdepth 3 -mindepth 3 -type f | awk -F '/' '{print $7 "/" $8 "/" $9}' | xargs -I II sh -c 'ln -s '$R_D_PATH'II '$B_D_PATH'II'	

#next, do all the anat, dwi, fmap, func files
	#WORKS
	find ${R_D_PATH} -maxdepth 4 -mindepth 4 -type f | awk -F '/' '{print $7 "/" $8 "/" $9 "/" $10}' | xargs -I II sh -c 'ln -s '$R_D_PATH'II '$B_D_PATH'II'	



fi














