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
app.listen(3005)
