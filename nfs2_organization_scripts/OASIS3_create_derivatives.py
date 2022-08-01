from pathlib import Path
from tqdm import tqdm
import argparse
import os


def parse():

    p = argparse.ArgumentParser(description='Create derivatives directory strucure for a dataset')

    p.add_argument('path', type=str, help="Path for dataset to create a derivatives directory for")

    a = p.parse_args()

    return a

a = parse()

dir_path = Path(a.path)

assert dir_path.exists(), "Error: Path {} does not exist".format(str(dir_path))
assert dir_path.is_dir(), "Error: Given path {} is not a directory".format(str(dir_path))

#create derivatives if it doesn't exist
derivatives_path = str(dir_path) + '/derivatives/'
if os.path.exists(derivatives_path):
    #print(derivatives_path)
    os.makedirs(derivatives_path)

derivatives_path = str(dir_path) + '/derivatives/'

for f in tqdm([x for x in dir_path.rglob('*')]):
    if f.name == 'derivatives' or f.is_file():
        continue
    #only copy over the directories
    #keep in mind: BIDS_path = str(dir_path)

    #first, check to make sure the derivatives directory doesn't exist
    extension = ""
    i = f
    while i.name != dir_path.name:
        extension = i.name + '/' + extension
        i = i.parent
    #print(extension)
    der_path = str(i) + '/derivatives/' + extension

    if Path(der_path).exists(): #if we have already created the directory, don't want to do it again
        continue
    #print(der_path)
    os.makedirs(der_path)




