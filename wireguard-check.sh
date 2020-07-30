#!/bin/bash

if [[ -z "$(ip link show | grep wg)" ]]; then
  echo "🦈 🔻"
else
  echo "🦈 ✔️"
fi
