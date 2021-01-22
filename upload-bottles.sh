#!/bin/bash

function uploadBottle {
	bottleVersion=`brew info --json $1 | jq --join-output '.[].installed[0] | .version'`
	echo $1 $bottleVersion
	
	brew bottle $1
	
	for bottle in `find . -name "$1*bottle.tar.gz" -maxdepth 1`; do
		mv $bottle ${bottle//--/-}
	done
	
	find . -name "$1*bottle.tar.gz" -maxdepth 1 | xargs gh release upload --repo mherod/$1 $bottleVersion || true
}

uploadBottle resharkercli
