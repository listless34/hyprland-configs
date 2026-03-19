#!/usr/bin/env bash

awk -F'\t' '
BEGIN { print "[" }
{
  n = split($5, kw, /\s*\|\s*/)

  printf "  {\n"
  printf "    \"emoji\": \"%s\",\n", $1
  printf "    \"group\": \"%s\",\n", $2
  printf "    \"subcategory\": \"%s\",\n", $3
  printf "    \"name\": \"%s\",\n", $4
  printf "    \"keywords\": ["

  for (i = 1; i <= n; i++) {
    printf "\"%s\"", kw[i]
    if (i < n) printf ", "
  }

  printf "]\n  }"

  if (NR < total) printf ","
  print ""
}
END { print "]" }
' total=$(wc -l <emoji.txt) emoji.txt >emoji.json
