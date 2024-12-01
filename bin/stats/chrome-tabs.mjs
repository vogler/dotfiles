#!/usr/bin/env -S zx --install
// Docs: https://google.github.io/zx/api

$.verbose = false

import { log, error } from 'console'
const errorr = (...a) => error(...a.map(x => chalk.red(x))) // can't redeclare error...

const j = JSON.parse(await $`OUTPUT_FORMAT=json chrome-cli list tabs`)
// log(j)
// output is flawed since active tab in window is only indentified via title which need not be unique

const windows = {}
for (const tab of j.tabs) {
  if (!(tab.windowId in windows)) {
    windows[tab.windowId] = { activeTab: null, tabs: {} } // `title: tab.windowName` redundant via activeTab
  }
  const window = windows[tab.windowId]
  if (tab.windowName == tab.title) window.activeTab = tab.id
  window.tabs[tab.id] = { title: tab.title, url: tab.url }
}

// console.dir(windows, { depth: null })
console.log(JSON.stringify(windows))
