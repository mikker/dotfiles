// Always do theater mode
window.addEventListener ("load", function() {
  if (window.location.pathname !== '/watch') {
    console.log('return early')
    return
  }

  var playlist

  document.getElementById('page').className = "watch watch-stage-mode watch-wide"
  document.getElementById('player').className = "content-alignment watch-medium"
  document.getElementById('watch7-container').className = "watch-wide"
// playlist = document.getElementById('watch-appbar-playlist')
// if (playlist) { playlist.setAttribute('style', 'top:120px') }
})
