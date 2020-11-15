#!/bin/bash

if [[ "$(ibus engine)" =~ "eng" ]]; then
  echo "eng"
else
  echo "vn"
fi
