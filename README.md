# reimagined-disco-k8s
Deploy the reimagined-disco app

# Secrets

## SOPS
Using [SOPS](https://github.com/getsops/sops/releases) and [age](https://github.com/FiloSottile/age) to handle secrets and encryption.

Generate your `age` keys:
`age-keygen -o private/age-key.txt`
Store the generated **public** key:  
`echo 'age1tjkygqahtv3gxrktknq33gxuql70ax8mludhxd98q5fpl3veqfzs5ask40' > public-age-keys.txt`

## Git hook
A simple git hook is configured to avoid commit of encrypted secrets.  
It just need to be activated:  
`git config core.hooksPath .githooks`

# Apply
```
sh ./decrypt.sh
kubectl apply -k k8s
sh ./encrypt.sh
```