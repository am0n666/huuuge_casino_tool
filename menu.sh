function check_is_root() {
    if [ "$(id -u)" -eq 0 ]; then
        if [ $(ps -o comm= -p $(ps -o ppid= -p $$)) = "sudo" ]; then
            # if sudo
            _result_=1
        else
            # as root
            _result_=2
        fi
    else
        # no root or sudo
        _result_=0
    fi
    echo $_result_
}

is_root=$(check_is_root)

if [ ! "$is_root" == 2 ]; then
    echo "You must login as root to use this script" 1>&2
    exit 99
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")"  && pwd)"
SCRIPTS_DIR="$DIR/tools/scripts"

PATH="$DIR/tools/bin:$PATH"

function import_functions {
    for FUNCTION in $SCRIPTS_DIR/*; do
        # skip directories
        if [[ -d $FUNCTION    ]]; then
            continue
            # exclude markdown readmes
        elif [[ $FUNCTION == "*.md" ]]; then
            continue
        elif [[ -f $FUNCTION   ]]; then
            # source the function file
            . $FUNCTION
        fi
    done
}

import_functions

dir_list=(
    "$DIR/profiles"
    "$DIR/tmp"
)

for check_dir in "${dir_list[@]}"; do
    ckdirex "$check_dir"
done

check_settings

source "$DIR/.settings"

if [ "$GAME_INSTALLED" == "0" ]; then
    echo
    echo "Please, install game first!"
    echo
    rm .settings
    exit 99
fi

export WORK_DIR SCRIPTS_DIR

trap 'del_tmp' EXIT # calls deletetempfiles function on exit

"$@"
