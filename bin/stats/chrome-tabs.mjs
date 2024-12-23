#!/usr/bin/env -S zx --install
// Docs: https://google.github.io/zx/api

$.verbose = false

import { log, error } from 'console'
const errorr = (...a) => error(...a.map(x => chalk.red(x))) // can't redeclare error...

const j = JSON.parse(await $`OUTPUT_FORMAT=json chrome-cli list tabs`)
// log(j) // example:
// {
//   "tabs": [
//     {
//       "id": "1057768852",
//       "title": "Inbox (9) - Gmail",
//       "url": "https://mail.google.com/mail/u/0/#inbox",
//       "windowId": "1057768851",
//       "windowName": "Inbox (9) - Gmail"
//     }, // ...
// output is flawed since active tab in window is only indentified via (title == windowName) which need not be unique

const windows = {}
for (const tab of j.tabs) {
  const window = windows[tab.windowId] ??= { activeTab: null, tabs: {} } // `title: tab.windowName` redundant via activeTab
  if (tab.windowName == tab.title) window.activeTab = tab.id
  window.tabs[tab.id] = { title: tab.title, url: tab.url }
}

// console.dir(windows, { depth: null })
console.log(JSON.stringify(windows))
