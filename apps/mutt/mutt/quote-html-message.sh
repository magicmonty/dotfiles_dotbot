#!/bin/sh
html2text.py | sed -e 's/^/> /g' | pbcopy
