var sqlite3 = require('sqlite3').verbose()
var db = new sqlite3.Database('/Users/mn/Library/Application Support/MobileSync/Backup/b501832cd76b90a6b6ad7f8fe059f30f65011b05/3d0d7e5fb2ce288813306e4d4636395e047a3d28')

var content_query = (query) => [
  'SELECT',
  '  DATETIME(date + 978307200, "unixepoch", "localtime") as Date,',
  '  h.id as \'Phone Number\',',
  '  text as Text',
  'FROM message m, handle h',
  'WHERE',
  '  h.rowid = m.handle_id AND',
  `  m.text LIKE '%${query}%'`,
  'ORDER BY m.rowid ASC;'].join('\n')

db.serialize(function () {
  console.log(content_query('Hello'))
  db.each(content_query('Hello'), function(err, row) {
    console.log(row)
  })
})
