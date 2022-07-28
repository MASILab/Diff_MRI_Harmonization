import argparse
from pathlib import Path
from bids_validator import BIDSValidator


def arg_parse():

    parser = argparse.ArgumentParser(description="Validate dataset as BIDS formatted.")

    parser.add_argument('path', type=str, help="Path to the dataset to be examined.")

    args = parser.parse_args()

    return args

args = arg_parse()

dir_path = Path(args.path)

assert dir_path.exists(), "Error: %s is not a valid path" % str(dir_path)
assert dir_path.is_dir(), "Error: %s is not a directory" % str(dir_path)

validator = BIDSValidator()

#print(validator.is_bids(str(dir_path)))


#BIDS Validator requires that paths be starting from the dataset, not the root
    #i.e. "/sub-XXXX/..." not "/nfs2/harmonization/BIDS/ADNI/sub-XXXX/..."
for f in dir_path.rglob('*'):
    path = ""
    while f.name != dir_path.stem and f.name != "":
        #print(f.name)
        if f.is_dir():
            path = f.name + "/" + path
        else:
            path = f.name
        f = f.parent
    path = "/" + path
    #print(path)
    if not validator.is_bids(path):
        print("{} is not a valid BIDS name. Dataset {} is not BIDS formatted.".format(path, dir_path.stem))
        #exit(0)
    else:
        print("{} is a valid path".format(path))
print("{} is a valid BIDS formatted dataset".format(dir_path.stem))
    

#print("{} is a valid BIDS formatted directory".format(dir_path.name))
#else:
#    print("{} is not a properly BIDS formatted directory :(".format(dir_path.name))



