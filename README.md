#### Goal
Remove all unwanted tags - Keep cover/artwork - Force trackID to "1"<br>
**No audio re-encoding**

#### Issues on m4a files : nosound on iOS or undesired tags
- m4a files are not correctly played (no sound) on iOS if trackID is 0
- It's impossible to directly change the trackID value
- In Apple world with iTunes / iTunesMatch / etc., some tags contain personnal data (AppleId / Name / email ...)
- Common tools cannot remove these Apple undesired tags
- I didn't want to re-encore all my music library

#### Required programs to run the script
- [ffmpeg] (http://ffmpegmac.net)
- [MP4box] (https://gpac.wp.mines-telecom.fr/downloads)

#### Installation on MacOSX
` sudo chmod +x cleanm4a.sh `<br>
Use automator to add it as a service and create a shortcut for context menu

#### Run on MacOSX
- file to clean must be the 1st argument on command line
- To apply cleaning for all the tracks in a folder, add these lines :<br>
  ```
  for m4afile in *.m4a
    do 
    [...]
    done
  ```
- To run the script on the full library (folders with subfolders etc.) use a find command as :<br>
` find ./ - type f -name "*.m4a" -exec cleanm4a.sh {} \; ` 



