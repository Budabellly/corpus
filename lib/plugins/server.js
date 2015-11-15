const fs = require('fs')
const express = require('express')
const app = express()
const bodyParser = require('body-parser')
const query = require('./sms/query.js')

app.post('/plugin/:plugin', bodyParser.urlencoded({type: () => true}), (req, res) => {
  query(req.body.content, rows => {
    res.write(JSON.stringify(rows))
    res.end()
  })
})
const serveFile = path => fs.createReadStream(__dirname + '/html' + path)
app.get('/', (req, res) => {
  serveFile('/index.html').pipe(res)
})
app.get('*', (req, res) => {
  if (req.url !== '/favicon.ico') {
    serveFile(req.url).pipe(res)
  } else {
    res.end()
  }
})
app.listen(3005)
