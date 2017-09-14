#!/bin/sh
contacts -Sf "%he&%n?%we&%n" "$1" | tr "&" "\t" | tr "?" "\n"
