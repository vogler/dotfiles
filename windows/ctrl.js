// run with `node ctrl.js` on Windows or WSL

const http = require('http')
const { execSync } = require('child_process')

const os = require('os').platform()
console.log('running on', os)

// config
const port = 3000
// WSL does not know how to run .ahk files, so we need to prepend the path to AutoHotkey
const ahk = (file) => (os == 'win32' ? '' : '/mnt/c/Program\\ Files/AutoHotkey/AutoHotkeyU64.exe ') + file + '.ahk'
// http://www.nirsoft.net/utils/nircmd.html would need to be installed for `nircmd.exe standby`, `nircmd.exe monitor off`
const cmds = {
  'suspend': ahk('suspend'), // DllCall via AutoHotkey. Find direct way to do this? `rundll32.exe powrprof.dll,SetSuspendState 0,0,0` also works but shouldn't be used according to https://stackoverflow.com/questions/37031935/setting-windows-to-energy-save-mode-using-node-js
}

const requestHandler = (request, response) => {
  console.log(new Date().toLocaleString(), request.url)
  response.end(`handled ${request.url}`) // should send some response before going into standby, otherwise the request in node-red errors with a timeout
  switch (request.url) {
    case '/suspend':
      execSync(cmds.suspend)
      break;
  }
}

const server = http.createServer(requestHandler)

server.listen(port, (err) => {
  if (err) {
    return console.log('could not start server:', err)
  }
  console.log(`server is listening on ${port}`)
})
