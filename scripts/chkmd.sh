#!/bin/sh

# We download gemini pages, in case they go offline.
# We store them in the .gemstore directory.

mkdir -p .gemstore

OLD_WORK_DIR="$(pwd)"
missing_file="$OLD_WORK_DIR/missing_links.txt"

timeout=3
golum=false
process_everything=false

while getopts "ahvg:c:t" opt; do
  case "${opt}" in
    v)
      echo "using verbose mode"
	  DEBUG=true
      ;;
    c)
		target_dir="$OPTARG"
      ;;
    a)
        process_everything=true
      ;;
    t)
		timeout="$OPTARG"
      ;;
    g)
        golum=true
     ;;
    h)
		echo -e "Options are -v (verbose), -c $dir (change directory) -t N (set time) and -a (all files here)."
		exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift "$(($OPTIND -1))"

find_markdown_link(){
    sed '/```/,//d' "$1" | \
    grep -Po '\[[^ ]+\]\(\K[^ )]+'
}

sort_into_url_or_file(){
	if [ "$(echo "$1" | grep '://' )" ]; then
		sort_url_types "$1"
	elif [ "$(echo "$1" | grep 'mailto:' )" ]; then
        continue
	elif [ "$(echo "$1" | grep 'magnet:' )" ]; then
        continue
	else
        if [ "$golum" = "false" ]; then
            check_file_link "$1"
        else
            check_file_link "$1".md
        fi
	fi
}

sort_url_types(){
	if [ "$(echo "$1" | grep -o http)" ]; then
		check_http_link "$1"
	elif [ "$(echo "$1" | grep -o gemini)" ]; then
		check_gemini_link "$1" && \
		download_gemini_page "$1"
	fi
}

check_gemini_link(){
	gemget --max-time "$timeout" "$1" -o- >/dev/null || echo "$1"  >> "$missing_file"
}

download_gemini_page(){
	target="$(basename $1)"
	if [ ! -f .gemstore/"$target" ]; then
		gemget "$1" -o .gemstore/"$target"
	fi
}

find_gemini_link(){
    sed '/```/,//d' "$1" | \
	grep -oP '^=> \Kgemini[^\s]*' | while read -r line; do
		download_gemini_page "$line"
	done
}

check_http_link(){
	curl --connect-timeout "$timeout" -Is "$1" >/dev/null || echo "$1"  >> "$missing_file"
}

check_file_link(){
	[ -f "$1" ] || echo "$1" >> "$missing_file"
}

check_if_markdown(){
        if [ "$(echo "$1" | rev | cut -d. -f1)" = "dm" ]; then
            [ -z "$DEBUG" ] || echo "$x is markdown"
        else
            echo "$1 ain't markdown"
            exit 1
        fi
}

####################

[ -z "$target_dir" ] || cd "$target_dir"

if [ "$process_everything" = "true" ]; then
    targets="$(ls *.md)"
else
    targets="$@"
fi

for x in $targets; do
	check_if_markdown "$x" && (
        find_markdown_link "$x" | while read -r line; do
            [ -z "$DEBUG" ] || echo checking "$line"
            sort_into_url_or_file "$line"
        done &
		find_gemini_link "$x"
    ) || (
        echo "$x is not markdown"
    )
done
