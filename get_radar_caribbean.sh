#!/bin/sh
#
# Finnish Meteorological Institute / Mikko Rauhala (2015-2022)
#
# SmartMet Data Ingestion Module for SYNOP Observations for RA IV
#

URL=https://barbadosweather.org/Radars/Caribbean/DBZ/

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

for i in 0 15 30 45
do
    file=$(date +%Y%m%d%H%M -d @$(( $(date -u +%s -d "$i minutes ago") / (15 * 60) * (15 * 60) )))_radar_caribbean_dbz.png
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
