#!/bin/sh

ATTACKER_AI_NAME=johniel01 DEFENDER_AI_NAME=hasi3_1 python app/main.py "$@" || echo "run error code: $?"
