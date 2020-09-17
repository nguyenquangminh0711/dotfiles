#!/bin/bash

if [[ "$(ibus engine)" = "Bamboo" ]]
then
  ibus engine xkb:us::eng
else
  ibus engine Bamboo
fi
