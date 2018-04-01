var express = require('express')  
var serveStatic = require('serve-static')

var staticBasePath = './dist';

var app = express()

app.use(serveStatic(staticBasePath, {'index': 'index.html'}))  
app.listen(8080)  
console.log("Server listening at http://localhost:8080")