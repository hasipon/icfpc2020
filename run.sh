#!/bin/sh

ATTACKER_AI_NAME=johniel02_hasi1 DEFENDER_AI_NAME=hasi3_2 python app/main.py "$@" || echo "run error code: $?"
