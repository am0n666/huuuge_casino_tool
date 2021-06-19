
function get_from_path() {
    [[ $# != 2 ]] && echo "usage: get_from_path <path> <dir|name|fullname|ext>" && return
    theFullFilePath="$1"
    theFileName=$(basename "$theFullFilePath")
    extension=$([[ $theFileName == *.* ]] && echo ".${theFileName##*.}" || echo '')
    # a hidden file without extenson?
    if [ "${theFileName}" = "${extension}" ]; then
        # hidden file without extension.  Fixup.
        name=${theFileName}
        extension=""
    fi
    case "$2" in
     dir) echo "${theFullFilePath%/*}"  ;;
     name) echo "${theFileName%.*}"  ;;
     fullname) echo "${theFileName}"  ;;
     ext) echo "${extension}"  ;;
    esac
}

function convert_path() {
    _input="$1"
    _output=""
    _fch_=$(printf %.1s "$_input")
    [ "$_fch_" = "/" ] && _output+="$_input"
    [ ! "$_fch_" = "/" ] && _output+="$(pwd)/$_input"
    _lch_=${_output:$((${#_output} - 1)):1}
    [ "$_lch_" = "/" ] && _output="${_output:0:${#_output}-1}"
    echo $_output
}

function add_sh_ext() {
	if [ ! -n "$1" ]; then
		exit
	fi
	dirpath="$(convert_path "$1")"	
	if [ -d "$dirpath" ]; then
		fcount="$(find "$dirpath" -maxdepth 1 -type f -name "*" | wc -l)"
		if [ "$fcount" == 0 ]; then
			echo "No files in this directory"
			exit
		else
			for file in $(ls -1 "$dirpath"|rev|cut -d'/' -f1|rev); do
				if [ -f "$dirpath/$file" ]; then
					mv "$dirpath/$file" "$dirpath/$file.sh"
				fi
			done
		fi
	fi
}

function del_sh_ext() {
	if [ ! -n "$1" ]; then
		exit
	fi
	dirpath="$(convert_path "$1")"
	if [ -d "$dirpath" ]; then
		fcount="$(find "$dirpath" -maxdepth 1 -type f -name "*.sh" | wc -l)"
		if [ "$fcount" == 0 ]; then
			echo "No files with .sh extension"
			exit
		else
			for file in $(ls -1 "$dirpath/"*.sh|rev|cut -d'/' -f1|rev); do
				file_name_wo_ext="$(get_from_path "$file" name)"
				mv "$dirpath/$file" "$dirpath/$file_name_wo_ext"
			done
		fi
	fi
}

function format_sh_files() {
	if [ ! -n "$1" ]; then
		exit
	fi
	formated_files_dir="$PWD/shfmt_out"
	mkdir "$formated_files_dir"
	dirpath="$(convert_path "$1")"
	if [ -d "$dirpath" ]; then
		fcount="$(find "$dirpath" -maxdepth 1 -type f -name "*" | wc -l)"
		if [ "$fcount" == 0 ]; then
			echo "No files with .sh extension"
			exit
		else
			for file in $(ls -1 "$dirpath"|rev|cut -d'/' -f1|rev); do
				shfmt -ln bash -i 0 "$dirpath/$file" > "$formated_files_dir/$file"
			done
		fi
	fi
}


#add_sh_ext "$1"
#del_sh_ext "$1"
format_sh_files "$1"
