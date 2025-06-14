#!/bin/bash
export SOPS_AGE_KEY_FILE=$(pwd)/private/age-key.txt

# create lock file
touch decrypted

SECFILES="secrets secrets-smb secrets-pg"

for SECFILE in $SECFILES; do
  FNAME="./k8s/$SECFILE.yaml"
  if [ -f $FNAME ]; then
    echo "Decrypting $FNAME ..."
    sops --decrypt --in-place $FNAME
  fi
done