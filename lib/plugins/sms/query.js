var sqlite3 = require('sqlite3').verbose()
var ls = require('ls')

var backups_dir = `${process.env['HOME']}/Library/Application Support/MobileSync/Backup/*/3d0d7e5fb2ce288813306e4d4636395e047a3d28`
var dbs = ls(backups_dir)
  .filter(db => db.file.length === 40)
  .map(db => {
    return new sqlite3.Database(db.full)
  })

var content_query = (query) => [
  'SELECT',
  '  DATETIME(date + 978307200, "unixepoch", "localtime") as Date,',
  '  h.id as Number,',
  '  text as Text',
  'FROM message m, handle h',
  'WHERE',
  '  h.rowid = m.handle_id AND',
  `  m.text LIKE '%${query}%'`,
  'ORDER BY m.rowid ASC;'].join('\n')

function results(cb, db) {
  db.serialize(function () {
    db.each(content_query('hey'), function(err, row) {
      cb(row)
    })
  })
}

dbs.forEach(results.bind(null, (row) => console.log(row)))
