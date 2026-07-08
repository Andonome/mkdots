#!/bin/sh

cd ~/gemini/splint.rs
git pull --recurse-submodules origin splint
make

rsync -autU --delete public/ /srv/gemini/splint.rs/

cd ~/gemini/ttrpgs.com
git pull --recurse-submodules origin ttrpgs
make

rsync -autU --delete public/ /srv/gemini/ttrpgs.com/

cd ~/websites
for x in splint.rs ttrpgs.com; do
	cd $x
	git pull -m'auto update'
	./update.sh
	cd ..
done
