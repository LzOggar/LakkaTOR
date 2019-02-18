#!/bin/bash

URL_LAKKA='http://www/.lakka.tv/'
URL_LAKKA_DOC='http://www.lakka.tv/doc/home'
URL_LAKKA_THUMBNAILS='http://thumbnailpacks.libretro.com/'

OUTPUT_FILE='thumbnailpacks.libretro.com.html'
ROMS_PATH='/storage/roms/downloads/'
THUMBNAILS_PATH='/storage/thumbnails/'
PLAYLISTS_PATH='/storage/playlists/'

function usage
{
	echo 'Usage :'
	echo -e '\t./LakkaTOR <cmd>'
	echo -e '\t-h, --help : use to get help.'
	echo -e '\t--setup : use to setup the system.'
	echo -e '\t--scan : use to automatically add games to playlists.\n'
	echo -e '\t[IMPORTANT] this script take cares of only zip file. For more informations, follow this urls :'
	echo -e "\t - $URL_LAKKA"
	echo -e "\t - $URL_LAKKA_DOC"
}

function getThumbnailPackNames
{
	wget -q "$1" -O "$OUTPUT_FILE"
	if [ -e "$OUTPUT_FILE" ]
	then
		thumbnailPackNames=$(grep -Eo '>(.+\.zip)<' < "$OUTPUT_FILE" | sed -e 's/>//' -e 's/<//' -e 's/ /_/g')
		if [ -n "$thumbnailPackNames" ]
		then
			echo "$thumbnailPackNames"
		else
			exit 0
		fi
	else
		exit 0
	fi
}

function setup
{
	for t in $1
	do
		th="${t//_/ }"
		roms_dir="$ROMS_PATH${th%.zip}"
		if [ ! -e "$roms_dir" ]
		then
			echo "[-] create directory $roms_dir"
			mkdir "$roms_dir"
			echo "[+] create directory $roms_dir done"
		else
			echo "[i] directory $roms_dir already exist"
		fi
		playlist_file="$PLAYLISTS_PATH${th%.zip}.lpl"
		if [ ! -e "$playlist_file" ]
                then
                        echo "[-] create file $playlist_file"
                        touch "$playlist_file"
                        echo "[+] create file $playlist_file done"
                else
                        echo "[i] file $playlist_file already exist"
                fi
		thumbnail_dir="$THUMBNAILS_PATH${th%.zip}"
		if [ -e "$thumbnail_dir" ]
		then
			echo "[i] $thumbnail_dir already exist"
		else
			url_thumbnail_pack="$URL_LAKKA_THUMBNAILS$th"
			thumbnail_pack="$THUMBNAILS_PATH$th"
			echo "[-] download $url_thumbnail_pack in $THUMBNAILS_PATH"
			wget -q "$url_thumbnail_pack" -O "$thumbnail_pack"
			echo "[+] download $url_thumbnail_pack in $THUMBNAILS_PATH done"
			if [ -e "$thumbnail_pack" ]
			then
				echo "[-] unpack $thumbnail_pack"
				unzip -q "$thumbnail_pack" -d "$THUMBNAILS_PATH"
				if [ $? -eq 0 ]
				then
					echo "[+] unpack $thumbnail_pack done"
					echo "[-] remove $thumbnail_pack"
					rm -f "$thumbnail_pack"
					if [ $? -eq 0 ]
					then
						echo "[+] remove $thumbnail_pack done"
					else
						echo "[i] remove $thumbnail_pack failed"
					fi
				else
					echo "[i] unpack $thumbnail_pack failed"
				fi
			else
				echo "[i] $thumbnail_pack not found"
			fi
		fi
	done
}

function addGamesToPlaylists
{
	folders=$(ls "$ROMS_PATH" | sed "s/ /_/g") # must use find "$ROMS_PATH" -type d but for our usefulness, it is OK.
	for folder in $folders
	do
        	folder="${folder//_/ }"
        	files=$(ls "$ROMS_PATH$folder" | sed "s/ /_/g") # must use find "$ROMS_PATH$folder" -type f, don't forget to change folder with folder="$(basename "$folder")"
        	playlist_name="$folder.lpl"
        	for file in $files
       		do
            	file="${file//_/ }"
            	playlist_path="$PLAYLISTS_PATH$folder.lpl"
            	zip_path="$ROMS_PATH$folder/$file"
            	count=$(grep -c "$file" "$playlist_path")
            	if [ $count -lt 1 ]
            	then
                   		echo "[-] add $file to $playlist_path"
                    	rom=$(unzip -Z -1 "$zip_path")
                    	{ echo "$zip_path#$rom"; echo "${file%.zip}"; echo "DETECT"; echo "DETECT"; echo "DETECT"; echo "$playlist_name"; } >> "$playlist_path"
            	        echo "[+] add $file in $playlist_path succeeded"
    	        else
                        echo "[i] $file already exist in $playlist_path"
                fi
	        done
	done
}

if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
	usage
else
	case "$1" in
		'--setup') thumbnail_pack_names=$(getThumbnailPackNames "$URL_LAKKA_THUMBNAILS") && setup "$thumbnail_pack_names";;
		'--scan') addGamesToPlaylists;;
		*) usage;;
	esac
fi
