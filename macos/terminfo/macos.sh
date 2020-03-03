#!/bin/bash

path="macos/terminfo"
find $path -name '*.terminfo' -exec tic -x {} \;
