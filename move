function cmn_echo_info_green {
	local green=$(tput setaf 2)
	local reset=$(tput sgr0)
	echo -e "${green}$@${reset}"
}

function cmn_echo_info_red {
	local red=$(tput setaf 1)
	local reset=$(tput sgr0)
	echo -e "${red}$@${reset}"
}

function cmn_echo_info_green {
	local green=$(tput setaf 2)
	local reset=$(tput sgr0)
	echo -e "${green}$@${reset}"
}

function cmn_echo_info_yellow {
	local yellow=$(tput setaf 3)
	local reset=$(tput sgr0)
	echo -e "${yellow}$@${reset}"
}

convert_path()
{
	if [ -n "$1" ]
	then
		source `pwd`/.settings
		old_path="$@"
		old_path_wo_slash=${old_path%/}
		case "$old_path_wo_slash" in
		/*)
				new_path="$old_path_wo_slash"
				;;
		*)
				new_path=`pwd`/"$old_path_wo_slash"
				;;
		esac
		echo $new_path
	fi
}

dir_exists()
{
	source `pwd`/.settings
	if [ -z "$1" ]
	then
		exit 0
	fi
	if [ -d "$1" ]
	then
		if [ -e "$1" ]
		then
			echo 1
		else
			echo 0
		fi
	else
		echo 0
	fi
}

file_exists()
{
	source `pwd`/.settings

	if [ ! -d "$1" ]
	then
		if [ -e "$1" ]
		then
			echo 1
		else
			echo 0
		fi
	else
		echo 0
	fi
}

get_profile_id()
{
	ID_FROM_FILE=`cat $1`
	RESULT_ID=$(echo "$ID_FROM_FILE" | awk -F"[" '{print $2}' | awk -F"]" '{print $1}')
	echo $RESULT_ID
}

get_id_from_bkp()
{
	tfile=$(convert_path "$1")

	file_test=$(file_exists "$tfile")

	if [ $file_test = 0 ]
	then
		clear
		cmn_echo_info_red "File not found:"
		cmn_echo_info_red $file_test
		exit 0
	else
		temp_dir="`pwd`/tmpid.$$"
		mkdir "$temp_dir"
		cd "$temp_dir"
		tar -xf "$tfile" files/breakpad/data
		cd $OLDPWD
		ID_FROM_FILE=`cat $temp_dir/files/breakpad/data`
		RESULT_ID=$(echo "$ID_FROM_FILE" | awk -F"[" '{print $2}' | awk -F"]" '{print $1}')
		echo $RESULT_ID
		rm -Rf "$temp_dir"
	fi
}

list_ids_from_dir() {
	pdir_list=$(convert_path "$1")

	if [ -f "$pdir_list/.player_ids" ]
	then
		rm $pdir_list/.player_ids
	fi
	for file in $pdir_list/*.tar
	do
		file_from="$file"
		_id_fname_=$(basename "$file_from")
		_id_of_player_=`get_id_from_bkp "$file_from"`
		_id_line_="$_id_fname_	 - $_id_of_player_"
		echo `basename "$file_from"`	-	`get_id_from_bkp $file_from` >> $pdir_list/.player_ids
#		echo `get_id_from_bkp $file_from` >> $pdir_list/.player_ids
	done
}

SCRIPTNAME=$(basename ${BASH_SOURCE[0]})
show_usage () {
    echo
    echo "Usage:"
    echo "	$SCRIPTNAME move_from_dir_to_dir [source_directory] [target_directory]"
    echo "	$SCRIPTNAME move_from_last_restored_to [target_directory]"
    echo

    exit 0
}

get_next_profile_name()
{
	source `pwd`/tools/default_dettings
	source `pwd`/.settings

	if [ -n "$1" ]
	then
		CURRENT_PROFILE=$1
		CURR=$CURRENT_PROFILE
		LN=$(echo "${#CURR}")
		if [ $LN == 1 ]
		then
			result=0`echo $CURRENT_PROFILE`
		else
			result=$CURRENT_PROFILE
		fi
		echo $result
	fi
}

count_bkps()
{
	source `pwd`/.settings
	source `pwd`/tools/test/convert_path
	tdir=$(convert_path "$1")
	TARGET_DIR="$tdir"
	count=0
	for f in $TARGET_DIR/*
	do
		extension="${f##*.}"
		if [ $extension == "tar" ]
		then
			count=$(command expr $count + 1)
		fi
	done
	echo $count
}

last_restored() {
	result=$PWD`cat $PWD/.last_restored`
	echo $result
}

last_restored_plus_one()
{
	source `pwd`/tools/default_dettings
	source `pwd`/.settings
	source `pwd`/tools/test/convert_path
	lr=`cat $1/.last_restored`
	fchar=`sh -c 'echo "${lr%${lr#?}}"'`
	if [ fchar = "0" ]
	then
		lrr=`echo $lr | cut -c 2-`
		c=`expr $lrr + 1`
		npn=$(get_next_profile_name $c)
		echo $npn > $1/.last_restored
	else
		c=`expr $lr + 1`
		npn=$(get_next_profile_name $c)
		echo $npn > $1/.last_restored
	fi
}

move_from_dir_to_dir() {
	source `pwd`/tools/default_dettings
	source `pwd`/.settings
	source `pwd`/tools/test/convert_path
	move_from=$(convert_path "$1")
	move_to=$(convert_path "$2")
	count=$(count_bkps "$move_to")
	c=`expr $bcnt + 1`
	for file in $move_from/*.tar
	do
		count=$(command expr $count + 1)
		file_from="$file"
		file_to="$(echo $move_to/$(get_next_profile_name $count).tar)"
		mv "$file_from" "$file_to"
	done
	bcnt=$(count_bkps "$move_to")
	pnme=$(get_next_profile_name $bcnt)
	echo $pnme > $move_to/.last_backuped
}

_move_from_last_restored_to() {
	source `pwd`/tools/default_dettings
	source `pwd`/.settings
	source `pwd`/tools/test/convert_path
	lr=$(last_restored)
	move_from=$(echo "$lr")
	move_to=$(convert_path "$1")
	bcnt=$(count_bkps "$move_to")
	c=`expr $bcnt + 1`
	file_from="$move_from"
	pnme=$(get_next_profile_name $c)
	file_to="$(echo $move_to/$pnme.tar)"
	mv "$move_from" "$file_to"
	echo $pnme > $move_to/.last_backuped
	echo $pnme".tar - $2" >> $move_to/.player_ids
}

function CheckIfProfileInDir {
	ttestfile="$1"
	testfileid=$(get_id_from_bkp $ttestfile)

	tfile="$tdir/.player_ids"

	file_test=$(file_exists "$tfile")

	if [ $file_test = 0 ]
	then
		list_ids_from_dir "$tdir"
	fi

	if [[ $(grep $testfileid $tfile) ]] ; then
		echo 1
	else
		echo 0
	fi

}

function move_from_last_restored_to {
	ttestfile=$PWD`cat .last_restored`
	
	tfileexists=$(file_exists $ttestfile)
	if [ $tfileexists = 0 ]
	then
		echo File not found: $ttestfile
		exit
	fi
	
	testfileid=$(get_id_from_bkp $ttestfile)

	tdir=$(convert_path "$1")
	
	cnfbkps=$(count_bkps $tdir)
	if [ $cnfbkps = 0 ]
	then
		_move_from_last_restored_to "$tdir" $testfileid
	else
		isindir=$(CheckIfProfileInDir $ttestfile "$tdir")

		if [ $isindir = 1 ]
		then
			echo Profile already in directory
			exit
		else
			_move_from_last_restored_to "$tdir" $testfileid

			tdirnamefrom="${ttestfile%/*}"
			tfnamefrom="${ttestfile##*/}"
			ppfrom=$(cmn_echo_info_yellow $tdirnamefrom)
			ppto=$(cmn_echo_info_yellow $tdir)
			pnfrom=$(cmn_echo_info_red $tfnamefrom)
			tpffrom=`cat $tdir/.last_backuped`
			pnto=$(cmn_echo_info_red $tpffrom.tar)
			echo "Moving from: $ppfrom/"$pnfrom 
			echo "to: $ppto/"$pnto 

#			echo "Moved to $tdir/" cmn_echo_info_red 01
		fi
	fi
}

if [ $# = 0 ];
then
	clear
	show_usage
else
	clear

#	cnt=$(count_bkps "$1")
#	echo $cnt
	"$@" "$1"
#	tdir=$(convert_path "$1")
#	echo "Moved to $tdir"
fi
