#!/usr/bin/env bash

FILESTEM=funnel

OPENSCAD_EXE=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

get_script_dir() {
  SOURCE="${BASH_SOURCE[0]}"
  SOURCE_DIR=$(dirname "${SOURCE}")
  SOURCE_DIR=$(cd -P "${SOURCE_DIR}" && pwd)
  echo "${SOURCE_DIR}"
}

set -euo pipefail

cd "$(get_script_dir)"

$OPENSCAD_EXE -v

# known spurious warning: https://github.com/openscad/openscad/issues/2888
$OPENSCAD_EXE --export-format binstl -o "${FILESTEM}-DO-NOT-PRINT.stl" $FILESTEM.scad  2>&1 | grep -v 'Fontconfig warning'
$OPENSCAD_EXE --export-format binstl -d "funnel_only=true" -o "${FILESTEM}-funnel.stl" $FILESTEM.scad 2>&1 | grep -v 'Fontconfig warning'
$OPENSCAD_EXE --export-format binstl -d "plug_only=true" -o "${FILESTEM}-plug.stl" $FILESTEM.scad  2>&1 | grep -v 'Fontconfig warning'

open -a Preview "${FILESTEM}-DO-NOT-PRINT.stl"
echo Done