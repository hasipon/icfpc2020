#!/bin/bash -x
cd "$(dirname "$0")"
tsc
sed -i 's/export default function run/function run/' visualizer.js
