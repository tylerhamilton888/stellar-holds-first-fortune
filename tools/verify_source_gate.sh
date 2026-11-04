#!/usr/bin/env bash
set -euo pipefail
echo 'PR validation can be focused. Its success is not proof of full release coverage.'
echo 'Use the Windows workflow: its source-gate matrix runs the full native suite on the candidate SHA.'
exit 1
