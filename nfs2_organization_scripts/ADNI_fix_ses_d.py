from pathlib import Path

paths = [Path('/nfs2/harmonization/BIDS/ADNI'), Path('/nfs2/harmonization/BIDS/ADNI-PreQual')]

for BIDS in paths:
    #do files first
    print("echo Now fixing {}...".format(BIDS.name))
    #print("echo Now fixing filenames...")
    #for f in BIDS.rglob('*'):
    #    if f.is_file():
    #        filename = f.name
    #        split = filename.split("-")
    #        new_name = '-'.join([split[0], split[1], "".join(split[2:4])])
    #        print("mv " + str(f) + " " + str(f.parent) + "/" + new_name)

    print("echo Done fixing filenames. Now fixing directory names...")
	
    #now do directories
    for f in BIDS.rglob('*'):
        if f.is_dir() and f.name[0:4] != "sub-" and f.name != "anat" and f.name != "dwi" and f.name != "derivatives":
            split = f.name.split("-")
            new_name = '-'.join([split[0], "".join(split[1:3])])
            #print(new_name)
            print("mv " + str(f) + " " + str(f.parent) + "/" + new_name)
	
    print("echo Done Fixing directory names.")


