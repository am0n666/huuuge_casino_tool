get_options()
{
source `pwd`/.settings
. `pwd`/tools/scripts/count_backups

PDIR=$1

count=0

for file in $PDIR/*
do
	count=$(command expr $count + 1)
	filename=$(basename "$file")
	fname="${filename%.*}"
	if [[ -d $file ]]
	then
		bkpscnt="["`count_backups $file`"]."
		echo $count "<DIR>"$bkpscnt"$filename" >> $TEMP_FILES_PATH/restopts.$$
	fi
	if [[ -f $file ]]; then
		echo $count "$fname" >> $TEMP_FILES_PATH/restopts.$$
	fi
done

OPTIONS=(
`cat $TEMP_FILES_PATH/restopts.$$`
)

LRF=$PDIR/.last_restored

if [ ! -e $LRF ]
then
	MM_TITLE="Last restored : BRAK"
else
	MM_TITLE="Last restored : "`cat $LRF`
fi

}

get_options "$1"
