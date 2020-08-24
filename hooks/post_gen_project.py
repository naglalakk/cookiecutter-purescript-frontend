import os
import shutil

has_user = "{{ cookiecutter.user }}"

if has_user != "y":
    os.remove("src/Data/User.purs")
    os.remove("src/Data/Email.purs")
    os.remove("src/Page/Login.purs")
    os.remove("src/Api/Utils.purs")
    shutil.rmtree("src/Form")
    shutil.rmtree("src/Resource")
