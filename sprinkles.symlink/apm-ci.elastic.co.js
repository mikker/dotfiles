(function () {
  let reran = false;

  apply();

  function apply() {
    const output = document.querySelector(".console-output");

    if (output) {
      const lines = output.innerHTML.split("\n");

      let script = false;
      const replaced = lines.map(line => {
        if (line.match(/SCRIPT EXECUTION BEGIN/)) {
          script = true;
        } else if (line.match(/SCRIPT EXECUTION END/)) {
          script = false;
        }

        return script ? paint(line, "black") : paint(line, "lightgray");
      });

      output.innerHTML = replaced.join("\n");
    } else {
      if (!reran) {
        setTimeout(apply, 250);
        reran = true;
      }
    }
  }

  function paint(line, color) {
    return `<span style='color: ${color}'>${line}</span>`;
  }
})()
