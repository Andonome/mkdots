#!/bin/sh

# Requiprements: pngquant, imagemagick,
# potrace, and svgcleaner.

set -e

if [ -z "$1" ]; then
	echo Provide an image file
	exit 1
fi

[ -n "$3" ] && echo too many arguments && exit 1

oldSize="$(du "$1" | awk '{print $1}')"

suffix="$(echo "$1" | rev | cut -d. -f1 | rev)"

name="$(basename -s .$suffix "$1")"

workDir="$(mktemp -d)"

returnDir="$(pwd)"

cp "$1" "$workDir"

cd "$workDir"

echo "Working in $workDir"

size=${2:-50}

##########

if [ $suffix = png ]; then
	magick "$1" -scale "$size"% -alpha off -threshold 50% "png8:out.png"
	rm "$(ls -S | head -n1)"
	pngquant *
	rm "$(ls -S | head -n1)"
	if [ ! -f "$1" ]; then
		mv "$(ls)" "$1"
	fi
    magick "$1" -flatten "$name".ppm
else
    magick "$1" -flatten "$name".ppm
fi

potrace --tight -ns "$name".ppm -o svg1.svg

svgcleaner svg1.svg svg2.svg
svgcleaner svg2.svg "$name".svg

newSize="$(du "$name".svg | awk '{print $1}')"

mv "$name".svg "$returnDir"

cd "$returnDir"

echo "Finished with $name"

echo Old size is $oldSize
echo New size is $newSize

rm -r "$workDir"
