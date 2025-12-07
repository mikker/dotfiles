// let clickCount = 0
//
// const buttonText = () =>
//   `nothing is more important to me than dulling my senses with never ending content (${clickCount})`
//
// window.addEventListener("load", function () {
//   const hours = new Date().getHours();
//
//   if (hours < 9 || hours >= 15) return;
//
//   const blinds = document.createElement("div");
//   Object.assign(blinds.style, {
//     position: "fixed",
//     top: 0,
//     left: 0,
//     right: 0,
//     bottom: 0,
//     background: "rgba(255, 255, 255, 0.1)",
//     zIndex: 9999999,
//     WebkitBackdropFilter: "blur(20px) grayscale(0.5)",
//     backdropFilter: "blur(20px) grayscale(0.5)",
//     display: "flex",
//     alignItems: "center",
//     justifyContent: "center",
//   });
//
//   const abort = document.createElement("button");
//   abort.innerHTML = buttonText();
//   abort.style.transform = "scale(1.25)"
//   abort.onclick = () => {
//     if (clickCount < 5) {
//       clickCount += 1
//       abort.innerHTML = buttonText()
//     } else {
//       blinds.remove();
//     }
//   };
//   blinds.appendChild(abort);
//
//   document.body.appendChild(blinds);
// });
