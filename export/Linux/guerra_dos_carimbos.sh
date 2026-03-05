#!/bin/sh
printf '\033c\033]0;%s\a' Carimbo FelpoJAM
base_path="$(dirname "$(realpath "$0")")"
"$base_path/guerra_dos_carimbos.x86_64" "$@"
