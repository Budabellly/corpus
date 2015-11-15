var sqlite3 = require('sqlite3').verbose()
var ls = require('ls')
var R = require('ramda')

module.exports = (q, cb) => {
  var backups_dir = `${process.env['HOME']}/Library/Application Support/MobileSync/Backup/*/3d0d7e5fb2ce288813306e4d4636395e047a3d28`
  var dbs = ls(backups_dir)
    .filter(db => db.file.length === 40)
    .map(db => {
      return new sqlite3.Database(db.full)
    })

  var content_query = (query) => [
    'SELECT',
    '  DATETIME(date + 978307200, "unixepoch", "localtime") as authored,',
    '  h.id as author,',
    '  text as content',
    'FROM message m, handle h',
    'WHERE',
    '  h.rowid = m.handle_id AND',
    `  m.text LIKE '%${query}%'`,
    'ORDER BY m.rowid ASC;'].join('\n')

  function results(cb, q, db) {
    db.serialize(function () {
      db.all(content_query(q.content), function(err, rows) {
        cb(rows)
      })
    })
  }

  var responses = [];
  dbs.forEach(results.bind(null, res => {
    responses.push(res)
    if (responses.length === dbs.length) {
      cb(R.reduce(R.concat, [], responses)
        .filter(x => x)
        .map(x => {
          x.date = x.authored && x.authored.split(' ')[0]
          return x
        }))
    }
  }, q));
}
