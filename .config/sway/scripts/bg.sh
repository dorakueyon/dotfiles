#!/bin/bash

wallpapers_path=$HOME/Images/wallpapers
width=3840
height=2160

curl --output $wallpapers_path/random.jpg -L https://source.unsplash.com/random/${width}x${height}
