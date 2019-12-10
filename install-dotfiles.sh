#!/usr/bin/env bash

install_pkg=''

function getopt_args() {
    while getopts ":p" opt; do
        case $opt in
        "p")
            install_pkg=1
            ;;
        *)
            echo "$0: undefined option argument."
            exit 1
            ;;
        esac
    done
    shift $((OPTIND-1))
}

getopt_args $@

### install packages ###

if [ ! -z "$install_pkg" ]; then
    echo "Installing packages.."
    sudo apt-get install -y git vim tmux > /dev/null 2>&1
    if [ "$?" != "0" ]; then
        echo "Error occured during package installation."
        exit 1
    fi
    echo "Done"
fi

### check bash file ###

bash_file=''

if [ -f "$HOME/.bashrc" ]; then
    bash_file='.bashrc'
elif [ -f "$HOME/.bash_profile" ]; then
    bash_file='.bash_profile'
else
    echo "$0: Cannot find bash file."
    exit 1
fi

### set path and setting file names ###

ABS_PATH=$(cd $(dirname $0) && pwd)
if [ -z "$ABS_PATH" ]; then
    echo "$ABS_PATH not accessble"
    exit 1
fi
DOTFILES=$ABS_PATH/dotfiles

cd $DOTFILES > /dev/null 2>&1
files=`find -type f | cut -c 3- | sed "s/.bash_swlee/$bash_file.swlee/g" | tr ' ' '\n'`
cd - > /dev/null 2>&1

echo "Source directory : $DOTFILES"
echo "Target directory : $HOME"

### bash file ###

echo "Modifying $bash_file"
src_str="[ -f \$HOME/$bash_file.swlee ] && . \$HOME/$bash_file.swlee"
tgt_tail=`cat $HOME/$bash_file | tail -n1`
if [ "$src_str" == "$tgt_tail" ]; then
    echo "  already importing $bash_file.swlee! skipping.."
else
    printf "\n########## added automatically by $(basename $0) ##########\n" >> $HOME/$bash_file
    echo $src_str >> $HOME/$bash_file
fi

### dotfiles ###

cp $DOTFILES/.bash_swlee $DOTFILES/$bash_file.swlee
while read -r file; do
    echo "Copying $file"
    if [ -f "$HOME/$file" ]; then
        echo "  already exists! skipping.."
    else
        mkdir -p `dirname "$HOME/$file"`
        cp $DOTFILES/$file $HOME/$file
    fi
done <<< "$files"
rm $DOTFILES/$bash_file.swlee

echo "Done"
