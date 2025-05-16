#!/bin/bash
touch decrypted
export SOPS_AGE_KEY_FILE=$(pwd)/private/age-key.txt
sops --decrypt --in-place ./k8s/secrets.yaml


