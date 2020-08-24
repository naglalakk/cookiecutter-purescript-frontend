exports.environment = process.env.ENVIRONMENT || ""
exports.apiURL      = process.env.API_URL     || "" {% if cookiecutter.user == "y" %}
exports.apiKey      = process.env.API_KEY     || "" {% endif %}
