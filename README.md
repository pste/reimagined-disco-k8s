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

```bash
./decrypt.sh
kubectl apply -k k8s
./encrypt.sh
```

# CICD with ArgoCD

This is created manually once:  
```bash
kubectl apply -f k8s/argocd.yaml
```
It creates the `Application` to be managed by ArgoCD (into the `argocd` namespace).  
Its scope is to update the `images` field in the `kustomize.yaml` file when the GitHub Action trigger fires.  

It is outside the kustomization to avoid circular references: it monitors and updates this file to avoid drifts.