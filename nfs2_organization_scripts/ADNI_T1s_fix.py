from pathlib import Path

for pattern in ['*MPRAGE*', '*SPGR*']:
    print('echo Starting on {} file renaming...'.format(pattern))
    for f in Path('/nfs2/harmonization/BIDS/ADNI/').rglob(pattern):
        splits = f.name.split("_", 2)
        end_splits = splits[2].split('_') #list of all text after ses-YYY split by '_'
        #must get last one and insert T1w before .nii.gz
        t = end_splits[len(end_splits)-1].split('.', 1) #t[0] = before .nii, t[1] = nii.gz or nii
        te = 'T1w.' + t[1]
        tes = '_'.join([t[0], te])  #new last elt of end_splits
        end_splits[len(end_splits)-1] = tes
        end_splits.insert(0, "acq-")
        fixed_name = "_".join([splits[0], splits[1], "".join(end_splits)])
        #Now, most of the aquisition name is put in place, just need to remove any additional hyphens
        parts = fixed_name.split('-', 3)
        last = ''.join(parts[len(parts)-1].split('-'))
        parts[len(parts)-1] = last
        finished_name = '-'.join(parts)
        print("mv " + str(f) + " " + str(f.parent) + '/' + finished_name)





