"use strict";

/*
 * See also http://stackabuse.com/node-http-servers-for-static-file-serving/
 */

var path = require('path');
var http = require('http');
var fs = require('fs');

var staticBasePath = './dist';

var cache = {};

var staticServe = function(req,res) {
  var resolvedBase = path.resolve(staticBasePath);
  var safeSuffix = path.normalize(req.url).replace(/^(\.\.[\/\\])+/, '');
  var fileLocation = path.join(resolvedBase, safeSuffix);

  // Check the cache first...
  if (cache[fileLocation] !== undefined) {
    res.statusCode = 200;

    res.write(cache[fileLoc]);
    return res.end();
  }

  // ...otherwise load the file
  fs.readFile(fileLocation, function(err, data) {
    if(err) {
      res.writeHead(404, 'Not Found');
      res.write('404: File Not Found');
      return res.end();
    }

    // Save to the cache
    cache[fileLocation] = data;

    res.statusCode = 200;

    res.write(data);
    return res.end();
  });
};

var httpServer = http.createServer(staticServe);

httpServer.listen(8080);
console.log("Server started, listening at http://localhost:8080");

/**


var filePath = req.url;
if (filePath == '/')
  filePath = '/dist/index.html';

filePath = __dirname+filePath;
var extname = path.extname(filePath);
var contentType = 'text/html';

switch (extname) {
    case '.js':
        contentType = 'text/javascript';
        break;
    case '.css':
        contentType = 'text/css';
        break;
}


fs.exists(filePath, function(exists) {

    if (exists) {
        fs.readFile(filePath, function(error, content) {
            if (error) {
                res.writeHead(500);
                res.end();
            }
            else {                   
                res.writeHead(200, { 'Content-Type': contentType });
                res.end(content, 'utf-8');                  
            }
        });
    }
})

*/