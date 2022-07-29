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


#for HCP
if [[ $1 == "HCP" ]]; then
	R_D_D_PATH="/nfs/HCP/data/" #path to raw subject directories
	
#create all subject directories and subdirectories
	mkdir $BIDS_DIR$1'/derivatives/'
	echo 'Creating subject directories...'
	find ${R_D_D_PATH} -mindepth 1 -maxdepth 1 -type d | awk -F '/' '{print $5 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/sub-II '$BIDS_DIR$1'/sub-IIanat '$BIDS_DIR$1'/sub-IIdwi '$BIDS_DIR$1'/sub-IIfunc'
	echo 'Done creating subject, subject subdirectories, and derivatives directory. Now creating derivatives subdirectories...'

#creating the derivatives subdirectories
	find ${R_D_D_PATH} -mindepth 1 -maxdepth 1 -type d | awk -F '/' '{print $5 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/derivatives/sub-II '$BIDS_DIR$1'/derivatives/sub-IIanat '$BIDS_DIR$1'/derivatives/sub-IIdwi '$BIDS_DIR$1'/derivatives/sub-IIfunc '$BIDS_DIR$1'/derivatives/sub-IIMNINonLinear '$BIDS_DIR$1'/derivatives/sub-IIMNINonLinear/fsaverage_LR32k '$BIDS_DIR$1'/derivatives/sub-IIMNINonLinear/Meta '$BIDS_DIR$1'/derivatives/sub-IIMNINonLinear/Results '$BIDS_DIR$1'/derivatives/sub-IIMNINonLinear/xfms '$BIDS_DIR$1'/derivatives/sub-IIdwi/eddylogs'
	echo 'Done creating derivatives subdirectories.'

#for HCPA
elif [[ $1 == "HCPA" ]]; then
	R_D_PATH="/nfs/HCPA/"

	#creating all subject directories
	find ${R_D_PATH} -mindepth 1 -maxdepth 1 -type d | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/sub-II'
	echo 'Done with subject directories. Now creating subdirectories...'
	#create all subdirectories
	find $R_D_PATH -mindepth 1 -maxdepth 1 -type d | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/sub-IIdwi '$BIDS_DIR$1'/sub-IIanat'
	echo 'Done creating subdirectories. Now creating derivatives...'
	#creating derivatives
	mkdir $BIDS_DIR$1/derivatives
	find ${R_D_PATH} -mindepth 1 -maxdepth 1 -type d | grep -v "derivatives" | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/derivatives/sub-II'
	find ${R_D_PATH} -mindepth 1 -maxdepth 1 -type d | grep -v "derivatives" | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/derivatives/sub-IIdwi '$BIDS_DIR$1'/derivatives/sub-IIanat'

#for HCPD
elif [[ $1 == "HCPD" ]];then
	R_D_PATH="/nfs/HCPD/"

#create all subject directories
	find ${R_D_PATH} -mindepth 1 -maxdepth 1 -type d | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/sub-II'
	echo 'Done with subject directories. Now creating subdirectories...'
#create all subdirectories
	find $R_D_PATH -mindepth 1 -maxdepth 1 -type d | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/sub-IIdwi '$BIDS_DIR$1'/sub-IIanat'
	echo 'Done creating subdirectories'
	#creating derivatives
	mkdir $BIDS_DIR$1/derivatives
	find ${R_D_PATH} -mindepth 1 -maxdepth 1 -type d | grep -v "derivatives" | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/derivatives/sub-II'
	find ${R_D_PATH} -mindepth 1 -maxdepth 1 -type d | grep -v "derivatives" | awk -F '/' '{print $4 "/"}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/derivatives/sub-IIdwi '$BIDS_DIR$1'/derivatives/sub-IIanat'


#for OASIS3
elif [[ $1 == "OASIS3" ]]; then
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

#for ADNI-PreQual
elif [[ $1 == "ADNI-PreQual" ]]; then
	R_D_PATH="${RAW_DIR}${1}/"

#creates all subject directories
	find ${R_D_PATH} -maxdepth 1 -mindepth 1 -type d | awk -F '/' '{print $6}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/sub-II'
	echo "Created all subject diectories."
#creates all session directories
	echo "Now creating session directories..."
	find ${R_D_PATH} -maxdepth 2 -mindepth 2 -type d | awk -F '/' '{print "sub-" $6 "/ses-" $7}' | awk -F '_' '{print $1 "-" $2}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/II' 
	echo "Finished creating session directories."
#creates all sub-session directories
	echo "Now creating sub-session directories..."
	find ${R_D_PATH} -maxdepth 2 -mindepth 2 -type d | awk -F '/' '{print "sub-" $6 "/ses-" $7}' | awk -F '_' '{print $1 "-" $2}' | xargs -I II sh -c 'mkdir '$BIDS_DIR$1'/II/dwi '$BIDS_DIR$1'/II/anat'
	echo "finished creating subsession directories."

fi
rmdir ${BIDS_DIR}$1












