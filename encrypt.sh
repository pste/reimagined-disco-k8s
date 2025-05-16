#!/bin/bash
export SOPS_AGE_RECIPIENTS=$(<public-age-keys.txt)

sops --encrypt --in-place --age ${SOPS_AGE_RECIPIENTS} ./k8s/secrets.yaml

rm decrypted