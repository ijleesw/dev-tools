#!/usr/bin/env bash

bash_ident='swlee'
install_pkg='N'
overwrite='N'
bash_file=''

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

if [ "$OSTYPE" == "linux-gnu" ]; then
    echo "Linux detected."
    bash_file='.bashrc'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS detected."
    bash_file='.bash_profile'
else
    echo "$0: unknown os -- $OSTYPE."
    exit 1
fi

### get path and dotfile names ###

ABS_PATH=$(cd $(dirname $0) && pwd)
if [ -z "$ABS_PATH" ]; then
    echo "$ABS_PATH not accessble"
    exit 1
fi
DOTFILES=$ABS_PATH/dotfiles

cd $DOTFILES > /dev/null 2>&1
files=$(find . -type f | cut -c 3- | sed "s/.bash_$bash_ident/$bash_file.$bash_ident/g" | tr ' ' '\n')
cd - > /dev/null 2>&1

### check before continue ###

echo "Source directory : $DOTFILES"
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
    if [ "$OSTYPE" == "linux-gnu" ]; then
        sudo apt-get install -y git vim tmux
    else
        brew install git vim tmux
    fi

    if [ "$?" != "0" ]; then
        echo "$0: Error occured during package installation."
        exit 1
    fi
    echo "Done"
fi

### bash file ###

echo "Modifying $bash_file"
src_str="[ -f \$HOME/$bash_file.$bash_ident ] && . \$HOME/$bash_file.$bash_ident"
grep_res=$(cat $HOME/$bash_file | grep "\\$src_str")
if [ "$overwrite" == "N" ] && [ ! -z "$grep_res" ]; then
    echo "  already importing $bash_file.$bash_ident! skipping.."
else
    printf "\n########## added automatically by $(basename $0) ##########\n" >> $HOME/$bash_file
    echo $src_str >> $HOME/$bash_file
fi

### dotfiles ###

cp $DOTFILES/.bash_$bash_ident $DOTFILES/$bash_file.$bash_ident
while read -r file; do
    echo "Copying $file"
    if [ $overwrite == "N" ] && [ -f "$HOME/$file" ]; then
        echo "  already exists! skipping.."
    else
        mkdir -p $(dirname "$HOME/$file")
        cp $DOTFILES/$file $HOME/$file
    fi
done <<< "$files"
rm $DOTFILES/$bash_file.$bash_ident

echo "Done"
