reponame="clubs"

repo_url="https://github.com/am0n666/$reponame.git"

homepwd="$PWD"
clubsdir="$homepwd/$reponame"
clubstmp="$homepwd/.clubs_temp"
clubsupdateddir="$clubstmp/$reponame"

function update_github() {
	g_u_em=am0n666x@gmail.com
	g_u_n=am0n666
	g_p=1Oliwka1_

	repo_name=$(basename "$PWD")
	git init --quiet
	git config user.email "$g_u_em"
	git config user.name "$g_u_n"
	git add -A
	git commit -m "xxx" --quiet
	git push https://$g_u_n:$g_p@github.com/$g_u_n/$repo_name.git --all --quiet
}

function upload_clubs() {
	mkdir -p "$clubstmp"
	cd $clubstmp
	git clone --quiet --branch master $repo_url
	cp -rf $clubsdir/* $clubsupdateddir/
	cd $clubsupdateddir
	update_github
	cd $homepwd
	rm -rf $clubstmp
}

function download_clubs() {
	if [ -d $clubsdir ]
	then
		rm -rf $clubsdir
	fi
	git clone $repo_url --branch master --quiet
	if [ -d $clubsdir/.git ]
	then
		rm -rf $clubsdir/.git
	fi
}

function nout() {
        "$@" > /dev/null 2>&1
}

function print_usage() {
	echo "Usage:"
	echo "clubs.sh download"
	echo "clubs.sh upload"
	echo "clubs.sh sync"
}

if [ ! -n "$1" ]
then
	print_usage
	exit
fi

cmd="$1"

if [ $cmd = "download" ]
then
	download_clubs
elif [ $cmd = "upload" ]
then
	upload_clubs
elif [ $cmd = "sync" ]
then
	echo ""
	echo "Synchronization of clubs, please wait"
	nout upload_clubs
	nout download_clubs
	echo "Done."
	echo ""
else
	print_usage
fi
