#!/bin/bash

if [[ "$(ibus engine)" = "Unikey" ]]
then
  ibus engine xkb:us::eng
else
  ibus engine Unikey
fi
