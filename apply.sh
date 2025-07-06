#!/usr/bin/env bash

set -euo pipefail

# --print-build-logs --verbose

sudo nixos-rebuild --show-trace --flake '.#vie' switch "$@"
