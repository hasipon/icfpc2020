#!/bin/sh

ATTACKER_AI_NAME=hasi DEFENDER_AI_NAME=hasi python app/main.py "$@" || echo "run error code: $?"
