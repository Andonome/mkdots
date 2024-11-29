#!/bin/bash
#
# Upload a video to peertube. Argument 1 is the filename (and the video name),  and argument 2 is the description (all in quotes of c.).
# Once run once, it stores credentials in pt_info.txt.
# You can change any variable in there by deleting the line and just rerunning the script.
# This script was built from
# https://www.artificialworlds.net/blog/2021/04/30/uploading-to-peertube-from-the-command-line/
# Dependencies: curl and fzy

# exit on error
set -e

# exit if any variable isn't defined, and say why
set -u

command -v fzy >/dev/null || echo "You need fzy for this to work"

[ -z "$1" ] && echo "Usage: ./ptup.sh [ video.mp4 ] 'my video about videos to be meta'"

[ -z "$2" ] && echo "Give a video description as the second argument"

DESCRIPTION="$2"

# grab file and filename
FILE_PATH="$1"
NAME="${FILE_PATH%.*}"
NAME="${NAME#*/}"

# we store info here
ptfile=pt_info.txt

if [ -e $ptfile ]; then
	source $ptfile
else
	echo "" > $ptfile
	echo "Looks like this is your first time sending a video. I need to ask some questions. If you mess up a question, you can just remove it from the $ptfile file"
fi

# if this is in a git then make sure the info's in a .gitignore, or you could commit a password to your git repo, ya plonker
[ ! -e .gitignore ] && git rev-parse 2>/dev/null && echo $ptfile > .gitignore

# We check we have all the variables needed, like 'which peertube instance', and if we don't have it, then ask for it.
# $1 = the variable name,
# $2 = the prompt to explain what's being asked
function askVars(){
	if ! grep -q $1 $ptfile; then
		echo "$2"
		read var && \
		echo "$1"="\"$var\"" >> $ptfile
		source $ptfile
	fi
}

askVars URL "What is your instance? e.g. peertube.linuxrocks.online"

askVars USERNAME "What's your username?"

USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]')

# sensible people store passwords in the "pass" program.
# otherwise, we just store it as plain text.
if ! command -v pass &>/dev/null; then
	askVars PASSWORD "What is your password?"
else
	if ! grep -q PASSNAME $ptfile; then
		if command -v fzy &>/dev/null; then
			if pass $URL &>/dev/null; then
				PASSNAME="$URL"
			else
				echo "Select your peertube password"
				PASSNAME=$(ls ~/.password-store/ 2>/dev/null | fzy)
				PASSNAME="${PASSNAME%.*}"
			fi
			echo "PASSNAME=$PASSNAME" >> $ptfile
		else
			askVars PASSNAME "what your 'pass' password called for peertube?"
		fi
	fi
	PASSWORD="$(pass $PASSNAME)"
fi

# now time to make sure the URL has all it needs

if ! $(echo $URL | grep -q https); then
	URL=https://$URL
fi

if ! grep -q CATEGORY $ptfile; then
	echo "Select a category (this will be used for all future videos)"
category_selection=$(echo '
Music
Films
Vehicles
Art
Sports
Travels
Gaming
People
Comedy
Entertainment
News & Politics
How To
Education
Activism
Science & Technology
Animals
Kids
Food' | fzy)

case "$category_selection" in
"Music")
	CATEGORY=1;;
"Films")
	CATEGORY=2;;
"Vehicles")
	CATEGORY=3;;
"Art")
	CATEGORY=4;;
"Sports")
	CATEGORY=5;;
"Travels")
	CATEGORY=6;;
"Gaming")
	CATEGORY=7;;
"People")
	CATEGORY=8;;
"Comedy")
	CATEGORY=9;;
"Entertainment")
	CATEGORY=10;;
"News & Politics")
	CATEGORY=11;;
"How To")
	CATEGORY=12;;
"Education")
	CATEGORY=13;;
"Activism")
	CATEGORY=14;;
"Science & Technology")
	CATEGORY=15;;
"Animals")
	CATEGORY=16;;
"Kids")
	CATEGORY=17;;
"Food")
	CATEGORY=18;;
esac

echo CATEGORY=$CATEGORY >> $ptfile
fi

API_PATH="$URL/api/v1"

if ! grep -q client_id $ptfile; then
	client_info=$(curl -s "${API_PATH}/oauth-clients/local")
	client_id=$(echo $client_info | jq -r ".client_id")
	client_secret=$(echo $client_info | jq -r ".client_secret")

	echo client_id=$client_id >> $ptfile
	echo client_secret=$client_secret >> $ptfile
fi

# Get the Channel ID

## start with dumpting all the info into a mega-variable
if ! grep -q CHANNEL_ID $ptfile; then
	channel_info=$(curl -s ${API_PATH}/accounts/$USERNAME/video-channels)

	## find which channel the user wants
	channel_selection=$(echo $channel_info | jq '.data | .[] | .name' | fzy)

	channel_selection=$(echo "$channel_selection" | sed s/\"//g)

	echo Selection is $channel_selection

	## use that channel name to select the right thing from the mega-variable
	CHANNEL_ID=$(echo "$channel_info" | jq --arg name "$channel_selection" -r '.data | .[] | select(.name == $name) |  .id')

	echo CHANNEL_ID=$CHANNEL_ID >> $ptfile
fi

if ! grep -q token $ptfile; then
	token=$(curl -s "${API_PATH}/users/token" \
	  --data client_id="${client_id}" \
	  --data client_secret="${client_secret}" \
	  --data grant_type=password \
	  --data response_type=code \
	  --data username="${USERNAME}" \
	  --data password="${PASSWORD}" \
	  | jq -r ".access_token")

	  echo "token=$token" >> $ptfile
fi

echo "Uploading ${FILE_PATH}"
curl "${API_PATH}/videos/upload" \
  -H "Authorization: Bearer ${token}" \
  --max-time 6000 \
  --form videofile=@"${FILE_PATH}" \
  --form channelId=${CHANNEL_ID} \
  --form name="$NAME" \
  --form category=$CATEGORY \
  --form licence=7 \
  --form description="$DESCRIPTION" \
  --form language=en \
  --form privacy=1 \
  --form tagsAllOf="[ $3 ]"

echo ""
