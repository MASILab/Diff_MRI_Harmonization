import argparse
from pathlib import Path


def parse():

    parser = argparse.ArgumentParser()

    parser.add_argument('dir', type=str, help='Path to BIDS dataset')

    args = parser.parse_args()
    return args


args = parse()
data_dir_path = args.dir

data_dir = Path(data_dir_path)

assert data_dir.exists(), "Error: path does not exist"


print("echo Moving mask files...")
for f in data_dir.rglob("*mask*"):
    #/nfs2/harmonization/BIDS/ADNI/sub-XXXX/ses-XXXX/dwi/*mask*
    dataset_dir = f.parent.parent.parent.parent
    sub = f.parent.parent.parent.name
    ses = f.parent.parent.name
    print("mv " + str(f) + " " + str(dataset_dir) + "/derivatives/" + sub + "/" + ses + "/dwi/")

    











