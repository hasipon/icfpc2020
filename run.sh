#!/bin/sh

AI_NAME=hasi python app/main.py "$@" || echo "run error code: $?"
