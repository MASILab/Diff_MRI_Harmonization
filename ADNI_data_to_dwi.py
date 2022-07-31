from pathlib import Path


BIDS_paths = ["/nfs2/harmonization/BIDS/ADNI", "/nfs2/harmonization/BIDS/ADNI-PreQual"]

for BIDS_path in BIDS_paths:
    print("echo Now doing {}...".format(BIDS_path))
    for f in Path(BIDS_path).rglob("*data*"):
        new_name = f.name.replace("data", "dwi")
        print("mv " + str(f) + " " + str(f.parent) + '/' + new_name)
    print("echo Done with {}".format(BIDS_path))
