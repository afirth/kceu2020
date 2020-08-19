## sops instructions

1. Install sops (assuming local bin)

```bash
curl -Lo sops https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux
chmod +x sops
mv sops ~/.local/bin
```

2. Ensure sops config is in the repo root. This config is the same for all repos at this time:

```bash
cat > ./.sops.yaml << EOF
# creation rules are evaluated sequentially, the first match wins
creation_rules:
        # all files using sops should include .sopsenc in the extension or be in a sopsenc folder
        - gcp_kms: projects/afirth-kceu2020/locations/global/keyRings/cloudbuild/cryptoKeys/sops
          path_regex: sopsenc
EOF
```

3. Create the plaintext yaml file containing the secret data. N.B. when using the kustomize secret generator (which you _always_ should - see afirth to update this doc if you find another case), secret data need not be base64 encrypted. [Canonical docs](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/secretGeneratorPlugin.md#secret-values-from-local-files)


4. Make sure sops can access [application default credentials](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login)

```
gcloud auth application-default login
```

## Encryption

> **_NOTE:_** all pathnames _shall_ include `sopsenc` e.g. `foo/sopsenc/myfile.yaml` - otherwise the build will break

`sops <filename>` will open for editing and decrypt on save

if you already have the plaintext, `sops -i -e <filename>`

bulk operations:
```
find . -type f -wholename '*sopsenc*' -print -exec sops -i -e {} \;
```

## Encrypting only parts of files

For some files, only one key needs to be encrypted. You can hack this with the `--encrypted-suffix` flag to `sops -e` e.g.

```
sops -i -d deploy/excitingdev/alertmanager-secret.sops.yaml
sops -e -i --encrypted-suffix=api_url deploy/excitingdev/alertmanager-secret.sops.yaml
```

In this example, the `slack_api_url` is now encrypted. `sops` with the editor will work as expected for future operations. You must start with plaintext locally, you cannot pass this to the sops editor nor add it later.

Note that you _must_ use `sops` to edit this file - editing the plaintext parts without using sops will result in `MAC mismatch. File has <MAC>, computed <MAC>` and everything will break

## Key rotation

sops can rencrypt with the latest key versions

```
find . -type f -wholename '*sopsenc*' -print -exec sops -r {} \;
```

## Decryption

> **_WARNING:_**  use `sops <filename>` to open in edit mode instead. Accidentally committing decrypted files to Github may result in a _lot_ of work.

Edit with `$EDITOR`:
```
sops <filename>
```

Decrypt in place:
```
find . -type f -wholename '*sopsenc*' -print -exec sops -i -d {} \;
```

## Notes

- KMS keys are managed at https://console.cloud.google.com/security/kms
- disabling a version will prevent decryption of any data encrypted at that version - understand what you are doing and why before considering that.
- I cannot concieve a reason to _delete_ a version in our current usage
- 30 day rotation
- secrets encrypted with sops should be made with `cloudbuild/sops` key
- cloudbuild has access to all keys in cloudbuild keyring
- don't add info in key name that's already in keyring name

## Why /sopsenc instead of .sops.extension or /secrets?

kustomize secret generators name the key after the filename, so a file called `foo.sops.yaml` as is convention would have the wrong key name. It is not always easy to change the mountpoint, especially with helm charts or upstream templates.

It also avoids nasty regexs required to avoid finding the `.sops.yaml` config file during bulk operations

`/secrets` and its variants may be present upstream in helm charts

## Why are we decrypting in place during build?

Makes `kustomize build` still work locally with the redacted contents
