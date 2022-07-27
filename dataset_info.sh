#!/usr/bin/bash

#help option
if [[ $1 == "-help" ]]; then
	echo "
#####################################################"
	echo "
Usage: dataset_info.sh <BIDS Dataset> <Metric>"
	echo "<BIDS Dataset> should be a directory chosen from /nfs2/harmonization/BIDS/"
	echo "<Metric> can be one of the following options:"
	echo "	-n	Gives the number of subjects in the dataset"
	echo "	-s	Gives the number of sessions in the dataset"
	echo "	-ms	Gives the number of subjects in the dataset with multiple sessions"
	echo "
EXAMPLE:
	"
	echo "	'./dataset_info.sh ADNI -n' will give the number of subjects in the ADNI dataset"
	echo "
#####################################################"
	exit 0
fi


#blank input check
if [[ -z $1 || -z $2 ]]; then
	echo "Usage: dataset_info.sh <BIDS Dataset> <Metric>"
	echo "Use 'dataset_info.sh -help' for more info."
	exit 1
fi

#check to make sure input dataset exists
if [[ ! -e /nfs2/harmonization/BIDS/$1 ]]; then
	echo "Error: dataset '$1' does not exist. Available datasets are in /nfs2/harmonization/BIDS/"
	exit 1
fi

BIDS_DIR="/nfs2/harmonization/BIDS/"

#This if statement performs the option specified by the user

#number of subjects
if [[ $2 == '-n' ]]; then
	echo "The number of subjects in the $1 dataset is:"
	find ${BIDS_DIR}$1 -mindepth 1 -maxdepth 1 -type d | grep -v "derivatives" | grep -v -i "EXTRAS"| wc -l

#number of sessions
elif [[ $2 == '-s' ]]; then
	echo "The total number of sessions in this dataset is:"
	NUM_SES=$(find ${BIDS_DIR}$1 -mindepth 2 -maxdepth 2 -type d | grep -v "derivatives" | grep -v -i "EXTRAS" | grep "ses-" | wc -l)
	if [[ $NUM_SES == '0' ]]; then
		find ${BIDS_DIR}$1 -mindepth 1 -maxdepth 1 -type d | grep -v "derivatives" | grep -v -i "EXTRAS"| wc -l
	else
		echo $NUM_SES
	fi

#unfinished
elif [[ $2 == '-ms' ]]; then
	echo 'The number of subjects with multiple sessions is:'
	NUM_SES=$(find ${BIDS_DIR}$1 -mindepth 2 -maxdepth 2 -type d | grep -v "derivatives" | grep -v -i "EXTRAS" | grep "ses-" | wc -l)
	NUM_SUB=$(find ${BIDS_DIR}$1 -mindepth 1 -maxdepth 1 -type d | grep -v "derivatives" | grep -v -i "EXTRAS"| wc -l)
	if [[ $NUM_SES == '0' || $NUM_SES == $NUM_SUB ]]; then
		echo $NUM_SES
	else	#unfinished part
		find ${BIDS_DIR}$1 -mindepth 2 -maxdepth 2 -type d | awk -F '/' '{print $6 "/" $7}'

fi





