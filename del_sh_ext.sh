
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

dirpath="$(convert_path "$1")"

cd "$dirpath"

for i in $(ls -d $dirpath/*); do

mv "$dirpath/$(get_from_path "$i" fullname)" "$dirpath/$(get_from_path "$i" name)"
#	sh_ext_fn="${i%%/}"
#	without_ext_fn="$(get_from_path "$sh_ext_fn" name)"
#	echo $sh_ext_fn $without_ext_fn
done

cd "$OLDPWD"

