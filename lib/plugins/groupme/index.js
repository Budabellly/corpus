var R = require('ramda')
var fs = require('fs')

var has_tags = R.curry((q, obj) => {
  if ('date' in q && (new Date(obj.created_at * 1000) + '').indexOf(q.date) == -1)
      return false
  if ('content' in q && !(obj.text || '').match(new RegExp(q.content.replace(/\s+/g, '.*'), 'i')))
      return false
  if ('author' in q && obj.name.indexOf(q.author) == -1)
      return false
  return true
})

module.exports = (q, cb) => {
  fs.readFile(__dirname + '/data.json', 'utf8', function (err, data) {
    var obj = JSON.parse(data)
    var list = R.reduce(R.concat, [], R.values(obj))
    var filteredList = R.filter(has_tags(q), list)
    cb(filteredList.map(x => {
      var date = new Date(x.created_at * 1000),
          y = date.getUTCFullYear(),
          m = date.getUTCMonth() + 1,
          d = date.getUTCDate();
      return {
        content: x.text,
        author: x.name,
        date: [y, m, d].join('-')
      }
    }))
  })
}
