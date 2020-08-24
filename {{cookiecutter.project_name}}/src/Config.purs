module Config where

foreign import environment  :: String
foreign import apiURL       :: String {% if cookiecutter.user == "y" %}
foreign import apiKey       :: String {% endif %}
