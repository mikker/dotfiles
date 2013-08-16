/*
* Instantly submit the form on hidemyass.com
* For use with Safari Keyword Searches etc.
* ---
* Setup this keyword search:
* http://hidemyass.com/proxy/index.php?site=http://@@@
*/
$(function(){
  // Auto-submit form if filled in already
  if ($("#hmaurl").attr("value") != "http://google.com")
      $("#hmabutton").trigger("click");

  // Minimize the header
  $("#hmalearnmore , #hmamainheader, #hmadonkeyhead, #hmatopheader").hide();
  $("#container").css({height: '48px'});
});
