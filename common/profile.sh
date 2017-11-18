source ~/.files/common/exports.sh
source ~/.files/common/aliases.sh
source ~/.files/common/functions.sh
source ~/private.sh

unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

complete -C aws_completer aws

# A `faric` auto completion utility
_fab()
{
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    local tags=$(fab -l 2>/dev/null | grep "^    " | awk '{print $1;}')
    COMPREPLY=($(compgen -W "${tags}" $cur))
}
complete -F _fab fab

complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null \
    || complete -o default -o nospace -F _git g

complete -F _docker d

complete -F _docker_machine dm

complete -F _docker_compose dc

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash}) for the details.
_fzf_compgen_path() {
  ag -g "" "$1"
}

complete -F _fzf_path_completion -o default -o bashdefault ag
complete -F _fzf_dir_completion -o default -o bashdefault tree

function _update_ps1() {
    PS1="$(powerline-shell $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# USER_BIN is declared in common/exports.sh
GCLOUD_DIR=$USER_BIN/google-cloud-sdk
if [ -d "$GCLOUD_DIR" ]; then
	. $GCLOUD_DIR/completion.bash.inc
	. $GCLOUD_DIR/path.bash.inc
fi
