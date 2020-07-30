#!/bin/bash

if [[ "$(dropbox status | head)" =~ "Up to date" ]]; then
  echo "📦 ✔️"
else
  echo "📦 ↕️"
fi
