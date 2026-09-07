# setup-rscli-action

Installs the [Reysys CLI](https://cli.reysys.com) and puts it on `PATH`.

```yaml
- uses: reysys-technology/setup-rscli-action@v2
  with:
    version: '1.2.2'

- run: rscli trivy upload-trivy-container-image-scan -f report.json --gate
  env:
    RS_CLIENT_ID: ${{ secrets.RS_CLIENT_ID }}
    RS_CLIENT_SECRET: ${{ secrets.RS_CLIENT_SECRET }}
```

**Pin the version.** A gate whose verdict can change between builds because the
binary changed underneath is not a gate. Omitting `version` installs the current
stable release and emits a warning telling you what to pin.

## Inputs

| Input | Default | Description |
|---|---|---|
| `version` | `latest` | Version to install, for example `1.2.2`. `latest` resolves the current stable release. |
| `download-host` | `cli.reysys.com` | Change only to use an internal mirror. |
| `skip-go-install` | — | **Deprecated and ignored.** |
| `go-version` | — | **Deprecated and ignored.** |

## Outputs

| Output | Description |
|---|---|
| `rscli-version` | The version string the installed binary reports. |

## What it does

Downloads the prebuilt binary for the runner's platform, verifies it against the
published `checksums.txt`, and adds it to `PATH`. Linux, macOS and Windows on
both amd64 and arm64.

It refuses to install a release that has been withdrawn, and it **fails closed**:
if it cannot determine whether a version is withdrawn — network partition, a
blocked request — it stops rather than installing. A revocation check that fails
open is defeated by a firewall rule.

## Upgrading from v1

v1 ran `go install`. That no longer works: the Go module proxy cannot read a
private repository, so it is permanently frozen at v1.2.1 and already fails for
anyone setting `GOPRIVATE` or `GOPROXY=direct`, which is common in enterprise CI.

Change `@v1` to `@v2` and delete `skip-go-install` and `go-version` if you set
them. No Go toolchain is needed any more, so you can drop `actions/setup-go` too.
Everything else is unchanged.
