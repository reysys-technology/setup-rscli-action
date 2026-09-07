#!/usr/bin/env bash
# Succeeds when installing a nonexistent version fails, which is what we want.
set -uo pipefail
output="$(curl -sS -o /dev/null -w '%{http_code}' "https://cli.reysys.com/rscli/0.0.0-does-not-exist/WITHDRAWN")"
[ "$output" = "404" ] || exit 1
output="$(curl -sS -o /dev/null -w '%{http_code}' "https://cli.reysys.com/rscli/0.0.0-does-not-exist/rscli_linux_amd64")"
[ "$output" = "404" ]
