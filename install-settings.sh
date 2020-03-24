#!/usr/bin/env bash

bash_ident=$USER
install_pkg='N'
overwrite='N'
bash_file=''
packages='git vifm vim tmux'

### getopts ###

while getopts ":po" opt; do
    case $opt in
    "p")
        install_pkg='Y'
        ;;
    "o")
        overwrite='Y'
        ;;
    *)
        echo "$0: undefined option argument."
        exit 1
        ;;
    esac
done
shift $((OPTIND-1))

### check os and set bash_file ###

is_linux() { [[ "$OSTYPE" == "linux-gnu"* ]]; }
is_macos() { [[ "$OSTYPE" == "darwin"* ]]; }

bash_file='.bashrc'
if is_linux; then
    echo "Linux detected."
elif is_macos; then
    echo "macOS detected."
else
    echo "$0: unknown os -- $OSTYPE."
    exit 1
fi

### get path and dotfile names ###

ORIGIN=$(cd $(dirname $0) && pwd)
if [ -z "$ORIGIN" ]; then
    echo "$ORIGIN not accessble"
    exit 1
fi
SETTINGS=$ORIGIN/settings

cd $SETTINGS > /dev/null 2>&1
files=$(find . -type f | cut -c 3- | sed "s/.bash_settings/$bash_file.$bash_ident/g" | tr ' ' '\n')
cd - > /dev/null 2>&1

### check before continue ###

echo "Source directory : $SETTINGS"
echo "Target directory : $HOME"
echo -n "Files to be copied : "
while read -r file; do
    echo -n "$file "
done <<< "$files"; echo ""
echo "Install Packages : $install_pkg"
echo "Overwrite files : $overwrite"

read -r -p "Continue? [y/N] " response
if ! [[ "$response" =~ ^[yY]$ ]]; then
    exit 0
fi; echo ""

### install packages ###

if [ "$install_pkg" == "Y" ]; then
    echo "Installing packages.."
    if is_linux; then
        sudo apt-get install -y $packages
    elif is_macos; then
        brew install $packages
    else
        echo "$0: unknown os -- $OSTYPE."
        exit 1
    fi

    if [ "$?" != "0" ]; then
        echo "$0: Error occured during package installation."
        exit 1
    fi
    echo "Done"
fi

### bash file ###

# $1: import parent
# $2: import child
import_bash_file() {
    if [ "$#" -ne "2" ]; then
        echo "Usage: import_bash_file <parent> <child>"
        exit 1
    fi

    echo "Modifying $1"
    src_str="[ -f \$HOME/$2 ] && . \$HOME/$2"
    grep_res=$(cat $HOME/$1 | grep "\\$src_str")
    if [ "$overwrite" == "N" ] && [ ! -z "$grep_res" ]; then
        echo "  already importing $2! skipping.."
    else
        printf "\n########## added automatically by $(basename $0) ##########\n" >> $HOME/$1
        echo $src_str >> $HOME/$1
        if [ "$1" == ".bashrc" ]; then
            echo 'if [ -z "$VIFM" ]; then vifm; fi' >> $HOME/$1     # set vifm as a default
        fi
    fi
}

import_bash_file $bash_file $bash_file.$bash_ident
if is_macos; then
    import_bash_file .bash_profile $bash_file
fi

### settings ###

cp $SETTINGS/.bash_settings $SETTINGS/$bash_file.$bash_ident
while read -r file; do
    echo "Copying $file"
    if [ $overwrite == "N" ]; then
        if [ -f "$HOME/$file" ]; then
            echo "  already exists! skipping.."
        else
            mkdir -p $(dirname "$HOME/$file")
            cp $SETTINGS/$file $HOME/$file
        fi
    else  # $overwrite == "Y"
        if [ -f "$HOME/$file" ]; then
            echo "  already exists! Original file moved to $file.bak"
            mv $HOME/$file $HOME/$file.bak
        fi
        mkdir -p $(dirname "$HOME/$file")
        cp $SETTINGS/$file $HOME/$file
    fi
done <<< "$files"
rm $SETTINGS/$bash_file.$bash_ident

### bits/stdc++.h ###

if is_macos; then
    echo "Copying stdc++.h to /usr/local/include/bits/ -- overwrite option does not hold"
    sudo mkdir -p /usr/local/include/bits/
    if [ -f "/usr/local/include/bits/stdc++.h" ]; then
        echo "  already exists! skipping.."
    else
        cp $ORIGIN/etc/stdc++.h /usr/local/include/bits/
    fi
fi

echo "Done"
