#!/bin/sh

# Required programs
# ffmpeg : http://ffmpegmac.net/
# MP4box : https://gpac.wp.mines-telecom.fr/downloads/

#sudo cp ~/Downloads/ffmpeg/ffmpeg /usr/bin/ffmpeg
#sudo chmod +x /usr/bin/ffmpeg

# One shot use : File to process = 1st line argument
m4afile="$1"
echo "###### File to process : $m4afile"

# Folder to backup original m4a and temp files as .aac and metadata
# mkdir backup

# Loop for multiple files in the same folder
# for m4afile in *.m4a
# do
# ........
# done

   
	m4afile_name="${m4afile%.*}"
   
   	# Extract and clean tags
	/Applications/ffmpeg/ffmpeg -i "$m4afile" -f ffmetadata "$m4afile-metadata.txt" 
	sed -n '/iTunSMPB/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt" 
	sed -n '/iTunNORM/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt" 
	sed -n '/encoder/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt" 
	sed -n '/account_type/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt"
	sed -n '/comment/!p' "$m4afile-metadata.txt" > temp && mv temp "$m4afile-metadata.txt"

	# Extract cover / artwork with AtomicParsley (default name  xtractPix_artwork_1.jpg)
	#########/Applications/ffmpeg/AtomicParsley "$m4afile" -extractPix
	# Extract cover / artwork with MP4Box (default name  m4afile but .m4a becomes .png ) 
	/Applications/ffmpeg/MP4Box/MP4Box  "$m4afile"  -dump-cover 

	# Create an aac version (easy to dump apparently)
	/Applications/ffmpeg/ffmpeg -i "$m4afile" -c:a copy -flags +global_header "$m4afile.aac" 

	# Backup original m4a file 
	# mv "$m4afile" backup/
	
	# Delete original file before creating a ne one
	rm "$m4afile" 
		
	# Create new m4afile with original sound track without re-encoding
	/Applications/ffmpeg/ffmpeg -i "$m4afile.aac" -i "$m4afile-metadata.txt" -map_metadata 1 -c:a copy -absf aac_adtstoasc -flags +global_header "$m4afile"  

	# mv "$m4afile-metadata.txt" backup/
	
	# Add cover /artwork
	#########/Applications/ffmpeg/AtomicParsley "$m4afile" Ð-artwork "xtractPix_artwork_1.jpg"
	/Applications/ffmpeg/MP4Box/MP4Box -itags cover="$m4afile_name.png" "$m4afile"  

	# mv "$m4afile_name.png" backup/

	# Optional cleaning
	rm "$m4afile.aac"
	rm "$m4afile_name.png"
	rm "$m4afile-metadata.txt"	



