dir_list=(
    _clb_/1/a
    _clb_/1/b
    _clb_/2/a
    _clb_/2/b
    _clb_/3/a
    _clb_/3/b
    _clb_/4/a
    _clb_/5/a
    _clb_/6/a
    _clb_/7/a
    _clb_/7/b
    _clb_/8/a
    _clb_/8/b
    _clb_/9/a
)

curr="$PWD"

for check_dir in ${dir_list[@]}; do
    if [ -n $check_dir ]; then
        #		if [ -d $check_dir/.info ]
        #		then
        #			rm -rf $check_dir/.info
        #		fi
        echo 00 >$check_dir/.last_restored
    fi
done
