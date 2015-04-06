express = require 'express'

app = express()
port = process.env.PORT || 3000

# Servce static assets
app.use '/',  express.static(__dirname + '/dist')

# Catch-all route to return index.html
app.get '*', (req, res) -> res.sendFile(__dirname + '/dist/index.html')

app.listen port, -> console.log('app listenting on port: ' + port)
