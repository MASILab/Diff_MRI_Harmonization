from pathlib import Path


for f in Path('/nfs2/harmonization/BIDS/ADNI-PreQual').rglob('*T1*'):
    print("mv " + str(f) + " " + str(f.parent) + '/' + f.name.replace('T1', 'T1w'))

