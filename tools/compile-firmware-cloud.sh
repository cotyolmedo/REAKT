#!/usr/bin/env bash
# Uses verified tools retained outside the checkout in this cloud instance.
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="/workspace/tools/venv/bin:$PATH"
for target in nodes/REAKT_Node gateway/REAKT_Gateway; do
  name="${target##*/}"
  /workspace/tools/arduino-cli/arduino-cli compile \
    --config-file /workspace/tools/arduino.yaml \
    --fqbn espressif:esp32:esp32 \
    --libraries /workspace/tools/arduino-libs \
    --library "$PWD/firmware/libraries/ReaktCore" \
    --build-property runtime.tools.xtensa-esp32-elf-gcc.path=/workspace/tools/esp32-tools/xtensa-esp32-elf \
    --build-property runtime.tools.esptool_py.path=/workspace/tools/esp32-tools/esptool \
    --build-property runtime.tools.ctags.path=/workspace/tools/ctags \
    --build-path "$PWD/build/$name" -j 2 "$PWD/firmware/$target"
done
