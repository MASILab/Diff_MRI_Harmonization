from pathlib import Path

def main():
    
    raw_dir = Path('/nfs2/harmonization/raw/HCPD')

    assert raw_dir.exists(), "Error: raw_dir does not exist: (%s)" % raw_dir

    HCPD_symlinks(raw_dir)

def HCPD_symlinks(raw_dir):

    
    for pattern in ["*bvec", "*bval", "*nii.gz"]:
        print("echo Now creating symlinks for " + pattern + " files...")
        for f in raw_dir.rglob(pattern):
            subject = f.parent.name
            new_sub = "sub-" + subject
            end = f.name.split(".", 1)[1]
            print("ln -s " + str(f) + " /nfs2/harmonization/BIDS/HCPD/" + new_sub + "/dwi/" + new_sub + "_dwi." + end)
        print("echo Done creating symlinks for " + pattern + " files.")

    print("echo Now creating derivative symlinks...")
    for f in raw_dir.rglob("*.txt"):
        subject = f.parent.name
        new_sub = "sub-" + subject
        print("ln -s " + str(f) + " /nfs2/harmonization/BIDS/HCPD/derivatives/" + new_sub + "/dwi/" + new_sub + "_" + f.name)
    print("Done creating derivative symlinks.")

if __name__ == "__main__":
    main()





