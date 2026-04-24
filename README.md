# reimagined-disco-k8s

Deploy the reimagined-disco app

# Secrets

## SOPS

Using [SOPS](https://github.com/getsops/sops/releases) and [age](https://github.com/FiloSottile/age) to handle secrets and encryption.

Generate your `age` keys:
`age-keygen -o private/age-key.txt`
Store the generated **public** key:  
`echo 'age1tjkygqahtv3gxrktknq33gxuql70ax8mludhxd98q5fpl3veqfzs5ask40' > public-age-keys.txt`

We keep secrets away from application deployment: they're manually managed.  
This way ArgoCD can manage the application without knowing any secret.

## Git hook

A simple git hook is configured to avoid commit of encrypted secrets.  
It just need to be activated:  
`git config core.hooksPath .githooks`

## Mounts

My mount points are statically provided. They're built on cluster level and the secret they use lives in detault `ns`.

# Apply

The application:  
```bash
kubectl apply -k k8s
```

The secrets:  
```bash
./decrypt.sh
kubectl apply -k k8s/secrets
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

# Postgres DB

About dropping privileges.  

Official Postgres uses user uid:999 (starts as root then drops privileges). We can use runAsUser: 999 BUT we need to make sure that the directory hostPath /var/mnt/hdd-data-1 is owned from uid:999 on the node:  
`talosctl -n $TALOSIP ls -l /var/mnt/hdd-data-1`  

To avoid problems we can use an initcontainer to fix permissions, then run as 999:  
```bash
spec:
    initContainers:     
      - name: fix-permissions
        image: alpine
        command: ["chown", "-R", "999:999", "/var/lib/postgresql/data"]
        volumeMounts:
          - mountPath: /var/lib/postgresql/data
          name: postgresdata
        securityContext:
          runAsUser: 0   # root solo per questo init container
    containers:
      - name: postgres
        ...
        securityContext:
          allowPrivilegeEscalation: false
          runAsNonRoot: true
          runAsUser: 999
          runAsGroup: 999
          capabilities:
            drop:
              - ALL
          seccompProfile:
            type: RuntimeDefault
```