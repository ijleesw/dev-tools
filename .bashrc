shopt -s expand_aliases
unset BASH_ENV

# My aliases
alias v='vim '
alias sudo='sudo '
alias p='python3 '
alias :q='exit'
alias :ㅂ='exit'
alias xgrep='grep -Iirn '
alias docker='sudo docker '
alias cint='rlwrap $HOME/.cint.py'
alias vm='vifm'
alias readp='read -p "Press ENTER or type command to continue"'
alias typora="open -a typora"
alias seokpi="ssh seok@seokpi.duckdns.org"

# ls aliases
alias ll='ls -lh'
alias la='ls -A'
alias ls='ls -GF'

# macos settings
if [[ $OSTYPE == "darwin"* ]]; then
    HISTCONTROL=ignoreboth
    export BASH_SILENCE_DEPRECATION_WARNING=1

    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    export GREP_OPTIONS='--color=auto'
fi

# Reset PS1 to support colorless vifm shell in both Linux and macOS
if [ -z "$VIFM" ]; then
    export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    export PS1='\[\033[00;36m\]vifm@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# tmux as a default terminal
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi

psg() {
    ps -ef | grep $1
}

pspid() {
    ps -ef | grep $1 | grep -v grep | awk '{printf "%s\t", $2; for (i=8; i<=NF; i++) printf " %s", $i; printf "\n"}' | grep $1
}

lsg() {
    if (( $# == 1 ))
    then
        ls | grep $1
    elif (( $# == 2))
    then
        ls $1 | grep $2
    else
        echo 'lsg: should have 1 or 2 arguments.'
    fi
}

cla() {
    clang++ -std=c++17 -g a.cc && echo 'Compiled.' && ./a.out
}

cl() {
    clang++ -std=c++17 $* && echo 'Compiled.' && ./a.out
}

k9() {
    kill -9 $*
}

kall() {
    ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
}

gitrb() {
    files=`git st | grep '^ M' | head -1 | awk '{print $2}'`
    if [ -z $files ]; then
        echo 'Nothing to rollback.'
    else
        git st | grep '^ M' | awk '{print $2}'
        git st | grep '^ M' | awk '{print $2}' | xargs git co --
        echo 'Rollback done.'
    fi
}

gdif() {
    if [ "$#" -ne 1 ]; then
        printf "Usage: gdif <commit_hash>\n"
        return 1
    fi

    #git diff $1~ $1
    git log -c $1
}

tmuxka() {
    li=$(tmux ls | grep -v attached | awk {' print $1 '} | sed 's/://')
    echo "$li" | xargs -I@ tmux kill-session -t @
    echo "$(echo $li | wc | awk '{ print $2 }') tmux sessions killed -- $(echo $li)"
}

jsonf() {
    if [ $# -ne 1 ]; then
        echo "Usage: jsonf <json string>"
        return 1
    fi

    echo $1 | python -m json.tool
}

jsonu() {
    if [ $# -ne 1 ]; then
        echo "Usage: jsonu <url>"
        return 1
    fi

    curl $1 | python -m json.tool
}

cpcp() {
    ./cpcp
}

