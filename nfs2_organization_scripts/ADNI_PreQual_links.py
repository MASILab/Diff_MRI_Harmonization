import os
import argparse
import subprocess
import sys
from pathlib import Path


def parse_args():
    parser = argparse.ArgumentParser(description="Create symlinks for ADNI-prequal dataset")

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
    assert (raw_dir.name == "ADNI-PreQual"), "Error: path given was not for ADNI-PreQual"
    assert (raw_dir.parent.name != "BIDS"), "Error: gave path of BIDS directory"

    assert raw_dir.exists(), "ERROR: raw_dir does not exist (%s)" % str(raw_dir)

    #now, we call the functions to create the symlinks

    Anat_symlinks(raw_dir)
    DWI_symlinks(raw_dir)

def Anat_symlinks(raw_dir):

    print("echo Now creating symlinks for 'anat' folder...")
    for anat_file in raw_dir.rglob("T1*"):
        #want to make sure we dont pick up "sessions with missing bvals" or "sessions with missing T1s"
        #print(str(anat_file))
        file_name = anat_file.name
        study_name = "sub-" + anat_file.parent.parent.name
        ses_split = anat_file.parent.name.split("_")
        ses_name = "ses-" + ses_split[0] + "-" + ses_split[1]
        new_file_name = study_name + "_" + ses_name + "_" + file_name
        new_path = "/nfs2/harmonization/BIDS/ADNI-PreQual/" + study_name + "/" + ses_name + "/anat/" + new_file_name
        print("ln -s " + str(anat_file) + " " + new_path)
    print("echo Done creating symlinks for 'anat' folder")

def DWI_symlinks(raw_dir):

    print("echo Now creating symlinks for 'dwi' folder...")
    for pattern in ["data*", "*bval", "*bvec"]:
        for dwi_file in raw_dir.rglob(pattern):
            file_name = dwi_file.name
            study_name = "sub-" + dwi_file.parent.parent.name
            ses_split = dwi_file.parent.name.split("_")
            ses_name = "ses-" + ses_split[0] + "-" + ses_split[1]
            new_file_name = study_name + "_" + ses_name + "_" + file_name
            new_path = "/nfs2/harmonization/BIDS/ADNI-PreQual/" + study_name + "/" + ses_name + "/dwi/" + new_file_name
            print("ln -s " + str(dwi_file) + " " + new_path)
    print("echo Done creating symlinks for dwi files")


if __name__ == "__main__":
        main()









