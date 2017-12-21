source ~/.files/common/profile.sh
if [ "$(uname)" == "Darwin" ]; then
    source ~/.files/macOS/profile.sh
else
    source ~/.files/linux/profile.sh
fi

PATH="/home/manigandan/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/manigandan/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/manigandan/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/manigandan/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/manigandan/perl5"; export PERL_MM_OPT;

eval "$(_TMUXP_COMPLETE=source tmuxp)"

# Project specified shortcuts
alias aircto='cd ~/go/src/code.aircto.in/root/aircto-backend && source config/app.env'
alias rdckr='sudo docker start lookupd && sudo docker start nsqd'
alias wrkr='./workerd'
alias server='aircto-backend'
alias gopath='export GOPATH=$HOME/gopher-lab'
alias goi='go install -v'
alias gob='go build -v'
