#!/bin/bash
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        mv $target $target.bak
    fi

    copy ${source} ${target}
}

BASE=`pwd`
if [ "$1" = "vim" ]; then
    for i in _vim*
    do
       link_file $i
    done
else
    for i in _*
    do
        link_file $i
    done
fi

git submodule sync
git submodule init
git submodule update
git submodule foreach git pull origin master
git submodule foreach git submodule init
git submodule foreach git submodule update

# setup command-t
#cd _vim/bundle/command-t
#rake make

#export WORKON_HOME=~/.projects
#export PROJECT_HOME=$HOME/projects/python
#source /usr/local/bin/virtualenvwrapper.sh 
#python $BASE/setup_virtualenv.py
#source ~/.bashrc

