#!/bin/bash

if [[ "$(ibus engine)" =~ "eng" ]]; then
  echo "🔤"
else
  echo "🇻🇳"
fi
