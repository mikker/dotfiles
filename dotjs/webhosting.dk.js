(function(){
  var cl = function(){ if(console && console.log) { console.log(arguments); } }

  $(function(){
    $("td a font").css({fontSize: '14px !important'});

    $("font table:nth-child(3)").hide();

    $("form:nth-child(3)").after(lengthInput);
    $("input#filterLength").change(function(e){
      $("tr").show("");
      if (this.value.length > 0) {
        filterResultsByLength(parseInt(this.value));
      }
    });
  });

  var lengthInput = $("<input placeholder='Max længde' type='text' length='4' style='border: 2px solid green' id='filterLength'>");

  var filterResultsByLength = function(length) {
    length = length+3;
    $("td a font").filter(function(){
      return ($(this).text().length > length);
    }).parents("tr").hide();
  }
}());
