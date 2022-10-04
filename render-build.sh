#!/bin/bash

echo "Building Hugo from a shell script"
hugo version
hugo --gc --minify
