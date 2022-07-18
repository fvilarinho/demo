#!/bin/bash

# Execute the IaC (Infrastructure as code) analysis with Snyk. Check only high severities.
snyk iac test ./iac --severity-threshold=high