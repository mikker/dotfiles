const output = document.querySelector(".console-output");

if (output) {
  const lines = output.innerHTML.split("\n");
  console.log(lines);

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
}

function paint(line, color) {
  return `<span style='color: ${color}'>${line}</span>`;
}
