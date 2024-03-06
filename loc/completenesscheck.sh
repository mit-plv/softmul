#!/bin/bash

comm -1 -3 <(grep -v '^#' loc/all-files.txt | sort) <(find src -name '*.v' | sort)
