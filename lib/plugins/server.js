const fs = require('fs')
const express = require('express')
const app = express()
const bodyParser = require('body-parser')
const texts = require('./sms/query.js')
const groupme = require('./groupme/index.js')

const plugins = {texts: texts, groupme: groupme}
app.post('/plugin/:plugin', bodyParser.urlencoded({type: () => true}), (req, res) => {
  var platform = req.params.plugin
  if (!plugins[platform]) {
    res.write(JSON.stringify([]))
    res.end()
  } else {
    plugins[platform](req.body, rows => {
      res.write(JSON.stringify(rows.map(row => {
        row.platform = platform;
        return row
      })))
      res.end()
    })
  }
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
