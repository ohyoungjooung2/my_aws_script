#!/usr/bin/env bash
aws iam generate-credential-report
aws iam get-credential-report --output text --query Content | base64 -d > $(date +%Y-%m-%d-%H:%M)_report.csv
