#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
c++ -std=c++17 -Wall -Wextra -Werror -pedantic -fsanitize=address,undefined -Ifirmware/libraries/ReaktCore/src tests/core_test.cpp -o build/core-test
./build/core-test

c++ -std=c++17 -Wall -Wextra -Werror -pedantic -fsanitize=address,undefined -Ifirmware/libraries/ReaktCore/src tests/link_sim_test.cpp -o build/link-sim-test
./build/link-sim-test
