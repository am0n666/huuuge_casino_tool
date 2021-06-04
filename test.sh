cut_restored_path() {
	source `pwd`/.settings
	if [ -n "$1" ]; then
		LINE="$1"
		replace=""
		result=${LINE//$WORK_DIR/$replace}
		echo $result
	fi
}

cut_restored_path "$@"

