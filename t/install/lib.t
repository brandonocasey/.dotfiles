#!/usr/bin/env bash

source "$dot_dir/install/lib.sh"

# is_installed
assert_raises "is_installed 'bash'" "0"
assert_raises "is_installed 'nopenope'" "1"
assert_raises "is_installed ''" "1"
