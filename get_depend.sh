#!/bin/bash

# Make results dir
DIR_NAME=./packages
mkdir $DIR_NAME

# Declare map
declare -A seen_library;

# Declare final list to install
FINAL_LIST='';

# Declare queue string
QUEUE='';

# Clear apt archives cache: Note this is necessary for the reinstall of packages to download all
rm /var/cache/apt/archives/*.deb

# Fetch arguments and add to pipe
for library in "$@"
do
	echo "Queueing root library $library";
	QUEUE="$QUEUE $library";
	seen_library[$library]=1;
done

# Run through dependency queue and add until end reached
DEPENDS_LIST="";
while true
do
	arr=($QUEUE);
	#echo ${arr[@]}
	if [[ ${#arr} > 0 ]]; then
		library=${arr[0]};
		QUEUE=${QUEUE/ ${library}/};
		DEPENDS_LIST="$DEPENDS_LIST $library"
	else
		break;
	fi

	echo "Fetching dependencies for $library"

	#Fetch dependencies
	CHILD_DEPENDS=$(sudo apt-rdepends $library)
	CHILD_DEPENDS=${CHILD_DEPENDS//$'\n'/\|};
	CHILD_DEPENDS=$( echo $CHILD_DEPENDS | sed -e 's/[^|]*Depends\:[^|]*//g' -e 's/\(|\| \)\+/ /g' )
	#echo "Dependencies: $CHILD_DEPENDS"
	DEPEND_ARR=($CHILD_DEPENDS)
	for dependency in $CHILD_DEPENDS
	do
		if [[ ${seen_library[$dependency]} == 1 ]]; then
			continue;
		else
			DEPENDS_LIST="$DEPENDS_LIST $dependency"
			seen_library[$dependency]=1;
		fi
	done
done

# Final Download steps
LINKS_LIST=$DIR_NAME/links.list;
echo "Downloading the following packages to $LINKS_LIST:";
echo $DEPENDS_LIST

# Get links to packages in LINKS_LIST file
sudo apt-get --print-uris --yes -d --reinstall install $DEPENDS_LIST | grep "http://" |  awk '{print$1}' | xargs -I'{}' echo {} | tee $LINKS_LIST;

# Save packages from links to current directory
wget --input-file $LINKS_LIST -P $DIR_NAME;
