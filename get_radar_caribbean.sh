#!/bin/sh
#
# Finnish Meteorological Institute / Mikko Rauhala (2015-2016)
#
# SmartMet Data Ingestion Module for SYNOP Observations for RA IV
#

URL=http://barbadosweather.org/Radars/Caribbean/DBZ/

if [ -d /smartmet ]; then
    BASE=/smartmet
else
    BASE=$HOME
fi

OUT=$BASE/editor/radar_caribbean
TMP=$BASE/tmp/data/radar_caribbean
TMPFILE=$TMP/radar-caribbean-composite-$$.txt

mkdir -p $TMP
mkdir -p $OUT

echo "URL: $URL"
echo "OUT: $OUT" 
echo "TMP: $TMP" 
echo "TMP File: $TMPFILE"

echo "Fetching file list..."
FILES=$(wget -nv -O - $URL | grep -oP 'href="\K[^"]+_radar_caribbean_dbz.png(?=")')
echo "done";

for file in $FILES
do
    echo -n $file
    if [ -s $OUT/$file ]; then
      	echo " cached"
    else
	echo "$URL$file" >> $TMPFILE;
	echo " download"
    fi
done 
if [ -s $TMPFILE ]; then
    cat $TMPFILE
    echo "Downloading files...";
    cat $TMPFILE | xargs -n 1 -P 50 wget -nv -N --no-check-certificate -P $OUT
    echo "done"
    rm -f $TMPFILE
fi




