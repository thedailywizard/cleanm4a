#!/bin/sh

# Required programs
# ffmpeg : http://ffmpegmac.net/
# MP4box : https://gpac.wp.mines-telecom.fr/downloads/

# One shot use : File to process = 1st line argument
m4afile="$1"
echo "###### File to process : $m4afile"

# Loop for multiple files in the same folder
# for m4afile in *.m4a
# do
# ........
# done
   
m4afile_name="${m4afile%.*}"
   
# Extract and clean tags
ffmpeg -i "$m4afile" -f ffmetadata "$m4afile-metadata.txt" 
sed -n '/iTunSMPB/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt" 
sed -n '/iTunNORM/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt" 
sed -n '/encoder/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt" 
sed -n '/account_type/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt"
sed -n '/comment/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt"

# Extract cover / artwork with MP4Box (default name  m4afile but .m4a becomes .png ) 
MP4Box  "$m4afile"  -dump-cover 

# Create an aac version (easy to dump apparently)
ffmpeg -i "$m4afile" -c:a copy -flags +global_header "$m4afile.aac" 

# Delete original file before creating a new one
rm "$m4afile" 
		
# Create new m4afile with original sound track without re-encoding
ffmpeg -i "$m4afile.aac" -i "$m4afile-metadata.txt" -map_metadata 1 -c:a copy -absf aac_adtstoasc -flags +global_header "$m4afile"  

# mv "$m4afile-metadata.txt" backup/
	
# Add cover /artwork
MP4Box -itags cover="$m4afile_name.png" "$m4afile"  

# Optional cleaning
rm "$m4afile.aac"
rm "$m4afile_name.png"
rm "$m4afile-metadata.txt"


