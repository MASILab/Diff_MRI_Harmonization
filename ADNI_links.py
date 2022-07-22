import os
import subprocess
import sys
import pathlib

argc = len(sys.argv)
if argc == 1:
	print("Usage: must pipe args to ADNI_links.py")

RAW_PATH = "/nfs2/harmonization/raw/ADNI/"
BIDS_PATH = pathlib.Path("/nfs2/harmonization/BIDS/ADNI/")

find_files_cmd = "find " + RAW_PATH +  " -maxdepth 3 -mindepth 3 -type f | head -n 2 | awk -F '/' '{print $6 '/' $7 '/' $8}'" #this cmd gets the file paths in raw ADNI
for line in subprocess.check_output(find_files_cmd, shell=True):
	print(line)
