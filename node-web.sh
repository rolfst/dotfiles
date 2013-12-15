#! /bin/bash
############################################################################
# this script depends on an installed virtualenvwrapper it maked use of 
# a virtualenv (python) to create an isolated node.js environment
############################################################################
echo -n "workon home dir " dir
read dir
export WORKON_HOME=$dir
source /usr/local/bin/virtualenvwrapper.sh
export export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
echo -n "project " 
read proj
mkvirtualenv $proj
echo $PWD
pip install nodeenv
nodeenv -p
deactivate; workon $proj
echo -n "Which build environment Yeoman or Brunch (Brunch) "
read build
case $build in
    [Yy][Ee][Oo][mM][aA][nN] )
        npm install -g yo grunt bower
        ;;
    * )
        npm install -g brunch
        ;;
esac
echo "done."
