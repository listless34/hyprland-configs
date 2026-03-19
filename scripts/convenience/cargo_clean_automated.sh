#!/usr/bin/env bash

cd ~/Documents/projects/rust_practice
find . -type f -name "Cargo.toml" | while read file; do
  dir=$(dirname "$file")
  echo "Running in $dir"
  (cd "$dir" && cargo clean)
done
