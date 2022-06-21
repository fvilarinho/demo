#!/bin/bash

# Execute the libraries analysis with Snyk. Check only high severities.
snyk test ./backend --severity-threshold=high