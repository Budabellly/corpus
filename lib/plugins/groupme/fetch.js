var http = require('http'),
    https = require('https');

function readResponse(resp, cb) {
  var buffer = [];
  resp.on('data', function (chunk) {
    buffer.push(chunk);
  });
  resp.on('end', function () {
    try {
      cb(JSON.parse(buffer.join('')));
    } catch(e) {
      cb([]);
    }
  });
}

var record = {};
function messagesForGroup(token, group, offset, cb) {
  https.get("https://api.groupme.com/v3/groups/" + group + '/messages?limit=100&token=' + token + (offset ? '&before_id=' + offset : ''), function (apiRes) {
    readResponse(apiRes, (data) => {
      try {
        var render = data.response.messages;
        record[group] = record[group] || [];
        record[group] = record[group].concat(render);
        if (record[group].length < data.response.count) {
          var ms = data.response.messages;
          messagesForGroup(token, group, ms[ms.length - 1].id, cb);
        } else {
          cb(record[group]);
        }
      } catch(e) {
        cb(record[group] || []);
      }
    });
  });
}

function getMessages(token, res, offset) {
  https.get("https://api.groupme.com/v3/groups?token=" + token, function (apiRes) {
    readResponse(apiRes, (groups) => {
      var groupFetches = {};
      groups.response.forEach(g => {
        messagesForGroup(token, g.group_id, 0, (xs) => {
          groupFetches[g.group_id] = xs;
          if (Object.keys(groupFetches).length === groups.response.length) {
            console.log(JSON.stringify(groupFetches));
            process.exit(0);
          }
        });
      });
    });
  });
  res.end();
}

// Make an app through GroupMe developer which points to localhost:3000
http.createServer(function (req, res) {
  if (req.url.indexOf('access_token') != -1) {
    var token = req.url.split('=')[1];
    res.writeHead(200, {'Content-Type': 'text/plain'});
    getMessages(token, res);
  } else {
    res.end();
  }
}).listen(3000);

