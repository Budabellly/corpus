const ACCESS_TOKEN = "e02cdc606d53013323ec07d3f3979cff"
var API = require('groupme').Stateless

API.Users.me(ACCESS_TOKEN, function(err,ret) {
  if (!err) {
    console.log("Your user id is", ret.id, "and your name is", ret.name);
  }
});





// var sqlite3 = require('sqlite3').verbose()
// var ls = require('ls')
//
// module.exports = (q) => {
//   var backups_dir = `${process.env['HOME']}/Library/Application Support/MobileSync/Backup/*/3d0d7e5fb2ce288813306e4d4636395e047a3d28`
//
//
//
//   var dbs = ls(backups_dir)
//     .filter(db => db.file.length === 40)
//     .map(db => {
//       return new sqlite3.Database(db.full)
//     })
//
//   var content_query = (query) => [
//     'SELECT',
//     '  DATETIME(date + 978307200, "unixepoch", "localtime") as Date,',
//     '  h.id as Number,',
//     '  text as Text',
//     'FROM message m, handle h',
//     'WHERE',
//     '  h.rowid = m.handle_id AND',
//     `  m.text LIKE '%${query}%'`,
//     'ORDER BY m.rowid ASC;'].join('\n')
//
//   function results(cb, q, db) {
//     db.serialize(function () {
//       db.each(content_query(q), function(err, row) {
//         cb(row)
//       })
//     })
//   }
//
//   dbs.forEach(results.bind(null, (row) => console.log(row), q));
// }
