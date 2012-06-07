#!/bin/env/python
import os 
base = os.getcwd()

postmkenv_text = """proj_name=$(echo $VIRTUAL_ENV|awk -F'/' '{print $NF}')
mkdir $HOME/projects/python/$proj_name
add2virtualenv $HOME/projects/python/$proj_name
cd $HOME/projects/python/$proj_name
cp """+ base +"""/developer_requirements.txt $HOME/projects/python/$proj_name/"""

postactivate_txt="""proj_name=$(echo $VIRTUAL_ENV|awk -F'/' '{print $NF}')
cd ~/projects/python/$proj_name
pip -r developer_requirements.txt"""

with open(os.path.expanduser("~/.projects/postmkvirtualenv"), 'a') as postmkenv:
    postmkenv.write(postmkenv_text)

with open(os.path.expanduser("~/.projects/postactivate"), 'a') as activate:
    activate.write(postactivate_txt)
