// // From https://github.com/norio-nomura/DisableTwitterEmoji
// (function () {
//   var reTwitterEmoji = /\/\/abs\.twimg\.com\/emoji\//i;

//     function handleBeforeLoadEvent(messageEvent) {
//     var e = messageEvent.target;
//     if (e.nodeName === "IMG" && messageEvent.url.match(reTwitterEmoji)) {
//       messageEvent.preventDefault();
//       var i = document.createTextNode(e.alt);
//       e.parentNode.replaceChild(i, e);
//       i.parentNode.normalize();
//       console.log("replaced!");
//     }
//   }

//   document.addEventListener("beforeload", handleBeforeLoadEvent, true);

// })();

