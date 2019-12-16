#!/usr/bin/env bash

if [[ -r ~/.bashrc ]]; then
   source ~/.bashrc
fi

export PATH="$HOME/.cargo/bin:$PATH"
