#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
target_dir=${HOME}/.local/bin
target=${target_dir}/devtasks
source_file=${root}/devtasks

mkdir -p "$target_dir"

if [[ -e "$target" && ! -L "$target" ]]; then
    backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    mv -- "$target" "$backup"
    printf 'Backed up existing devtasks to %s\n' "$backup"
fi

ln -sfn -- "$source_file" "$target"
printf 'Installed %s -> %s\n' "$target" "$source_file"
