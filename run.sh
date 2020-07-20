#!/bin/sh

ATTACKER_AI_NAME=johniel01_shiota_hasi2 DEFENDER_AI_NAME=hasi3_1 python app/main.py "$@" || echo "run error code: $?"
