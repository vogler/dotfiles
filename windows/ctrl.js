// run with `node ctrl.js` under Windows (or WSL with alternative cmd below)
const http = require('http')
const port = 3000
const { execSync } = require('child_process');
const cmd = 'suspend.ahk' // DllCall via AutoHotkey. Find direct way to do this?
// const cmd = '/mnt/c/Program\ Files/AutoHotkey/AutoHotkeyU64.exe suspend.ahk' // WSL does not know how to run .ahk files, so we need to add the path to AutoHotkey

const requestHandler = (request, response) => {
  console.log(new Date().toLocaleString(), request.url)
  response.end(`handled ${request.url}`) // should send some response before going into standby, otherwise the request in node-red errors with a timeout
  if(request.url == '/standby')
    execSync(cmd)
}

const server = http.createServer(requestHandler)

server.listen(port, (err) => {
  if (err) {
    return console.log('could not start server:', err)
  }
  console.log(`server is listening on ${port}`)
})
