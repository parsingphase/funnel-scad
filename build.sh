#!/usr/bin/env bash

FILESTEM=birdfeederFunnel

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
echo Rendering overview
$OPENSCAD_EXE --export-format binstl -o "output/${FILESTEM}-DO-NOT-PRINT.stl" $FILESTEM.scad  2>&1 | grep -v 'Fontconfig warning'
echo Rendering funnel
$OPENSCAD_EXE --export-format binstl -D "funnel_only=true" -o "output/${FILESTEM}-funnel.stl" $FILESTEM.scad 2>&1 | grep -v 'Fontconfig warning'
echo Rendering plug
$OPENSCAD_EXE --export-format binstl -D "plug_only=true" -o "output/${FILESTEM}-plug.stl" $FILESTEM.scad  2>&1 | grep -v 'Fontconfig warning'

open -a Preview "output/${FILESTEM}-DO-NOT-PRINT.stl"
echo Done