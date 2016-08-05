(function (window, document) {
  'use strict'

  console.log('dotjs is clicking shit')

  function parseParams (search) {
    return search
    .replace(/^\?/, '')
    .split('&')
    .reduce(function (params, kv) {
      kv = kv.split('=')
      params[kv[0]] = kv[1]
      return params
    }, {})
  }

  function clickFirstResult () {
    var elm = document.querySelector('h3.r a')
    if (elm) {
      elm.click()
    } else {
      setTimeout(clickFirstResult, 100)
    }
  }

  var params = parseParams(window.location.search)
  if (params.q && params.q.match(/\!/)) {
    clickFirstResult()
  }

  var searchField = document.getElementById('lst-ib')
  searchField.onkeydown = function (event) {
    if (event.keyCode !== 13) return
    if (!event.target.value.match(/\!/)) return
    setTimeout(function () { clickFirstResult() }, 500)
  }
})(window, document)
