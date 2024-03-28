#!/usr/bin/env node

// This script measures the time it takes to open a new [tab]/window in Chrome, load some [html] and execute [js] which then closes the server and the window.
// Requires the `chrome-cli` package to be installed globally: `npm install -g chrome-cli` or `brew install chrome-cli`.

// With a long-running Chrome that accumulated lots of memory, the browser time ranged from 1.5s to 11.5s, probably due to swapping on a 8GB MBA.

var http = require('http');
const port = process.env.PORT || 8080;

const date = () => (new Date()).toLocaleString('de');
console.log(date(), `Starting server on http://localhost:${port}`);

console.time('total');

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/html'});
  if (req.url === '/') {
    res.write(`<script>fetch("http://localhost:${port}/js").then(_ => window.close());</script>`);
    console.timeEnd('html');
    console.time('js');
  } else if (req.url === '/js') {
    res.write('ok');
    console.timeEnd('js');
    console.timeEnd('browser');
    server.close();
  }
  res.end();
});
server.on('close', () => {
  console.timeEnd('total');
});
server.listen(port);

const { execSync } = require('child_process');
console.time('browser');
console.time('tab');
execSync(`chrome-cli open "http://localhost:${port}" -n`);
console.timeEnd('tab');

console.time('html');
