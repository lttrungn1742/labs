#!/bin/bash
docker run -v ../zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py \
    -t $1 -g gen.conf -J report.json --hook=/zap/wrk/my-hooks.py