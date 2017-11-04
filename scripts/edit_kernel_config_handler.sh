#!/bin/bash

config=$(readlink -f $1)
shift
edit_kernel_config=$(readlink -f $(dirname $(readlink -f $0))/edit_kernel_config.sh)
cat "$config" | edit_kernel_config "$@" | sponge "$config"

