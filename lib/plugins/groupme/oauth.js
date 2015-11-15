const ACCESS_TOKEN = "e02cdc606d53013323ec07d3f3979cff"
const CALLBACK_URL = "http://localhost:3000"
const REDIRECT_URL = "https://oauth.groupme.com/oauth/authorize?client_id=b5tN         fqUqwcicI3rGsdufEUKaRQXp7fffRWSUJ8fkih899R8N"

window.location.replace(REDIRECT_URL);



window.location.replace(CALLBACK_URL + "/?access_token=" + ACCESS_TOKEN);
