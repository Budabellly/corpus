var parseArgs = opts => require('minimist')(process.argv.slice(2), opts)
var opts = {string: ["d", "c", "a", "n"], boolean: ["--meta"]};
var argv = parseArgs(opts)
var query = require('./query')
query(argv.c)
