var R = require('ramda')
var fs = require('fs')

var parseArgs = opts => require('minimist')(process.argv.slice(2), opts)
var opts = {string: ["d", "c", "a", "n"], boolean: ["--meta"]};
var argv = parseArgs(opts)
var has_tags = obj => {
  if ('d' in argv && (new Date(obj.created_at * 1000) + '').indexOf(argv.d) == -1)
      return false;
  if ('c' in argv && (obj.text || '').indexOf(argv.c) == -1)
      return false;
  if ('a' in argv && obj.name.indexOf(argv.a) == -1)
      return false;
  return true;
}

var obj;
var list;
var filtered_list;
fs.readFile('data.json', 'utf8', function (err, data) {
  if (err) throw err
  obj = JSON.parse(data)
  list = R.reduce(R.concat, [], R.values(obj))
  filtered_list = R.filter(has_tags, list)
  console.log(filtered_list)
});
