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

function convert_path() {
	_input="$1"
	_output=""
	_fch_=$(printf %.1s "$_input")
	[ "$_fch_" = "/" ] && _output+="$_input"
	[ ! "$_fch_" = "/" ] && _output+="`pwd`/$_input"
	_lch_=${_output:$((${#_output}-1)):1}
	[ "$_lch_" = "/" ] && _output="${_output:0:${#_output}-1}"
	echo $_output
}

function get_player_club_id() {
	save_file="$1"

	str_line_num=`awk 'match($0,v){print NR; exit}' v="lastClubId" $save_file`

	if [ -z "$str_line_num" ]
	then
			exit
		else
			char1='<key name="lastClubId" type="int">'
			char2='</key>'

			n=1
			while read line; do
				if [ $n == $str_line_num ]; then
					full_line=$line
				fi
				n=$((n+1))
			done < $save_file
			str_club_id=`echo $full_line | awk -v FS="($char1|$char2)" '{print $2}'`
			echo $str_club_id
	fi
}

function get_player_chips_count() {
	save_file="$1"

	str_line_num=`awk 'match($0,v){print NR; exit}' v="chips\"" $save_file`

	if [ -z "$str_line_num" ]
	then
			exit
		else
			char1='<key name="chips" type="int">'
			char2='</key>'

			n=1
			while read line; do
				if [ $n == $str_line_num ]; then
					full_line=$line
				fi
				n=$((n+1))
			done < $save_file
			str_chips_count=`echo $full_line | awk -v FS="($char1|$char2)" '{print $2}'`
			echo $str_chips_count
	fi
}

function get_player_diamonds_count() {
	save_file="$1"

	str_line_num=`awk 'match($0,v){print NR; exit}' v="diamonds\"" $save_file`

	if [ -z "$str_line_num" ]
	then
			exit
		else
			char1='<key name="diamonds" type="int">'
			char2='</key>'

			n=1
			while read line; do
				if [ $n == $str_line_num ]; then
					full_line=$line
				fi
				n=$((n+1))
			done < $save_file
			str_diamonds_count=`echo $full_line | awk -v FS="($char1|$char2)" '{print $2}'`
			echo $str_diamonds_count
	fi
}

function get_player_id() {
	bpf="$1"
	cat $bpf | awk -F"[" '{print $2}' | awk -F"]" '{print $1}'
}

list_club_ids_from_dir() {
	pdir_list=$(convert_path "$1")
	if [ -f "$pdir_list/player_club_ids" ]
	then
		rm $pdir_list/player_club_ids
	fi
	temp_dir="`pwd`/tmpid.$$"
	mkdir "$temp_dir"
	for file in $pdir_list/*.tar
	do
		file_from="$file"
		cd $temp_dir
		tar -xf "$file_from" files/save/save1
		_result_=$(get_player_club_id "$temp_dir/files/save/save1")
		echo $_result_ >> $pdir_list/club_ids
	done
	rm -rf $temp_dir
}

_FILE1_="/data/data/com.huuuge.casino.slots/files/save/save1"
_FILE2_="/data/data/com.huuuge.casino.slots/files/breakpad/data"



#list_club_ids_from_dir "$1"
#get_player_club_id "$_FILE1_"

cfile=`echo clubs/$(get_player_club_id "$_FILE1_")`

if [ -f $cfile ]
then
	echo $(get_player_club_id "$_FILE1_")
	cat $cfile
else
	nano -l $cfile
fi

#get_player_chips_count "$_FILE1_"
#get_player_diamonds_count "$_FILE1_"
#get_player_id "$_FILE2_"
