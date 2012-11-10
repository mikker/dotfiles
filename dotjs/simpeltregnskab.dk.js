(function($){
  $("input#attachment").change(function(){
    $(this).parents("form").trigger("submit");
  });
})(jQuery);
