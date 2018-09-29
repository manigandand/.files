function search {
    grep -irl \
        --exclude=\*.{pyc,swp,un~,png,jpg,o} \
        --exclude-dir=".git" \
        --exclude-dir=".cache" \
        --exclude-dir=".tox" \
        --exclude-dir="node_modules" \
        --exclude-dir="bower_components" \
        --exclude-dir="dist" \
        --exclude-dir="tmp" \
        --exclude-dir=".sass-cache" \
        --exclude-dir=".cache-loader" \
        --exclude-dir="Appknox" \
        --exclude-dir="build" \
        --exclude-dir="uploads" \
        --exclude-dir=".ropeproject" \
        --color "$*" .
}

function mkd() {
    mkdir -p "$@" && cd "$@"
}

# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
    function diff() {
        git diff --no-index --color-words "$@"
    }
fi

function ak_prs {
    open "https://github.com/pulls?q=is%3Aopen+is%3Apr+user%3Aappknox+label%3Areview"
}

function fix-git {
    git gc --prune=now
    git remote prune origin
}

function keys {
	ssh-add ~/.ssh/google_compute_engine
	ssh-add ~/.ssh/id_rsa
}

function 2nd {
    awk '{print $2}'
}
