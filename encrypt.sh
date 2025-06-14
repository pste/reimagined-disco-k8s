#!/bin/bash
export SOPS_AGE_RECIPIENTS=$(<public-age-keys.txt)

SECFILES="secrets secrets-smb secrets-pg"

for SECFILE in $SECFILES; do
  FNAME="./k8s/$SECFILE.yaml"
  if [ -f $FNAME ]; then
    echo "Encrypting $FNAME ..."
    sops --encrypt --in-place --age ${SOPS_AGE_RECIPIENTS} $FNAME
  fi
done;

# rm lock file
rm decrypted