SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#EXECUTE_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../..";pwd)"
EXECUTE_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")";pwd)"

function del_tmp() {
	source $EXECUTE_DIR/.settings
	rm -rf $TEMP_FILES_PATH/*
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

function get_from_path() {
	[[ $# != 2 ]] && echo "usage: get_from_path <path> <dir|name|fullname|ext>" && return
	theFullFilePath="$1"
	theFileName=$(basename "$theFullFilePath")
	extension=$([[ "$theFileName" == *.* ]] && echo ".${theFileName##*.}" || echo '')
	# a hidden file without extenson?
	if [ "${theFileName}" = "${extension}" ] ; then
		# hidden file without extension.  Fixup.
		name=${theFileName}
		extension=""
	fi
	case "$2" in
		dir) echo "${theFullFilePath%/*}"; ;;
		name) echo "${theFileName%.*}"; ;;
		fullname) echo "${theFileName}"; ;;
		ext) echo "${extension}"; ;;
	esac
}

function last_restored_from() {
	if [ -n "$1" ]; then
		_dir_="$(convert_path "$1")"
		_lr_file_="$_dir_/.last_restored"

		if [ -f "$_lr_file_" ]; then
			_lr_="$(cat $_lr_file_)"
			echo "$_lr_"
		fi
	fi
}

function restore_next() {
	source "$EXECUTE_DIR/.settings"
	if [ -n "$1" ]; then
		_dir_="$(convert_path "$1")"
		_tmp_profiles_list_file_="$TEMP_FILES_PATH/tmp_profiles_list_file.$$$"

		_profiles_count_="$(cd $_dir_; ls *.tar | wc -l; cd $OLDPWD)"
		_last_restored_=$(last_restored_from "$_dir_")

		echo "_profiles_count_: $_profiles_count_"
		echo "_last_restored_: $_last_restored_"
		echo "_tmp_profiles_list_file_: $_tmp_profiles_list_file_"

		_current_=1
		cd "$_dir_"
		for profile_bkp_file in `ls *.tar | sort -n`
		do

#			echo "$_current_ - $profile_bkp_file"
			echo $(get_from_path ${profile_bkp_file} name) >> "$_tmp_profiles_list_file_"
			_next_=$_current_
			let _next_+=1
#			echo "$_next_"
			LN=$(echo "${#_current_}")
			if [ $LN == 1 ]; then
				_cur_=0$(echo $_current_)
			else
				_cur_=$_current_
			fi
#echo $_cur_
			if [ "$_cur_" == "$_last_restored_" ] || [ "$_current_" == "$_last_restored_" ]; then
#				awk 'NR == $_cur_' $_tmp_profiles_list_file_
#				_next_=$(let _current_+=1)
#				_next_=`let _cur_+=1`
#let _current_+=1
c=`expr $_cur_ + 1`
#echo $c
_n_=`awk 'NR == $c' $_tmp_profiles_list_file_`

awk 'NR == $c' $_tmp_profiles_list_file_
#echo $_n_
#				_next_profile_name_=$_n_
				#echo "$_cur_"
			fi
			let _current_+=1
		done
		cd "$OLDPWD"
		_last_profile_name_=`awk 'NR == $c' $_tmp_profiles_list_file_`

		echo "_next_profile_name_: $_next_profile_name_"
		echo "_last_profile_name_: $_last_profile_name_"
	fi
}

restore_next "$1"
del_tmp
exit


if [ -n "$1" ]; then
	_dir_=$(convert_path "$1")
	lrp_nr=1
	lrp_next=1
	cd $_dir_

	files_count=$(ls *.tar | wc -l)

	if [ -f $_dir_/.last_restored ]; then
	lrp_name=$(cat $_dir_/.last_restored)
	fi

	for profile_bkp_file in `ls *.tar | sort -n`
	do
		_lrp_name=$(get_from_path "$profile_bkp_file" name)
		echo ${profile_bkp_file} >> $OLDPWD/.fl_tmp.txt
	done
	cd $OLDPWD
	awk 'NR == 6' $PWD/.fl_tmp.txt
fi
