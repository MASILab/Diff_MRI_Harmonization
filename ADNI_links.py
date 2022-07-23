import os
import argparse
import subprocess
import sys
from pathlib import Path


def parse_args():
    parser = argparse.ArgumentParser(description="Create symlinks for ADNI dataset")

    parser.add_argument('raw_dir', type=str, help='Path to original dataset')

    args = parser.parse_args() 
    return args

def main():
    args = parse_args()
    raw_dir = Path(args.raw_dir)
    #print(raw_dir)
    #print(raw_dir.rglob('*SPGR*'))
    #i = [x for x in raw_dir.rglob('*SPGR*')]
    #print(len(i))

    assert raw_dir.exists(), "ERROR: raw_dir does not exist (%s)" % raw_dir

    #now, we call the functions to create the symlinks

    ADNI_anat_symlinks(raw_dir)
    ADNI_dwi_symlinks(raw_dir)

def ADNI_anat_symlinks(raw_dir):

    for pattern in ("*SPGR*", "*MPRAGE*"): #creates symlinks for SPGR and MPRAGE files (T1 files that go into 'anat' folder)
        print("echo 'Now creating symlinks for " + pattern + " files...'")
        for anat_file in raw_dir.rglob(pattern):
            filename = anat_file.name   #just the filename
            study_name = str(filename).split("_", 3)[3] #study name (e.g Accelerated_SAG_IR-SPRAGE.nii.gz)
            sub_name = anat_file.parent.parent.name #subject
            bids_ses_list = str(anat_file.parent.name).split('_')   
            bids_ses_name = "ses-" + bids_ses_list[0] + "-" + bids_ses_list[1]   #reconstructing session name into BIDS format
            bids_filename = sub_name + "_" + bids_ses_name + "_" + study_name #name of symlink in BIDS directory
            bids_path = "/nfs2/harmonization/BIDS/ADNI/" + sub_name + "/" + bids_ses_name + "/anat/" + bids_filename #full path for BIDS symlink
            print("ln -s " + str(anat_file) + " " + str(bids_path))
        print("echo 'Done creating symlinks for " + pattern + " files'")

def ADNI_dwi_symlinks(raw_dir):

    print("echo 'Now creating symlinks for dwi  files...'")
    for dwi_file in raw_dir.rglob("data*"):
        filename = dwi_file.name   #just the filename
        sub_name = dwi_file.parent.parent.name #subject
        bids_ses_list = str(dwi_file.parent.name).split('_')   
        bids_ses_name = "ses-" + bids_ses_list[0] + "-" + bids_ses_list[1]   #reconstructing session name into BIDS format
        bids_filename = sub_name + "_" + bids_ses_name + "_" + filename #name of symlink in BIDS directory
        bids_path = "/nfs2/harmonization/BIDS/ADNI/" + sub_name + "/" + bids_ses_name + "/anat/" + bids_filename #full path for BIDS symlink
        print("ln -s " + str(dwi_file) + " " + str(bids_path))
    print("echo 'Done creating symlinks for dwi files'")


if __name__ == "__main__":
        main()









