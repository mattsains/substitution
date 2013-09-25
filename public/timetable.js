$(document).ready(function()
{
   $('table#timetable td textarea').hide().autogrow().focusout(function()
   {
      //triggered when a textarea loses focus
      if ($(this).val()=="")
         $(this).hide();
      else
         $(this).removeClass("focus");
   });
   $('table#timetable td:has(textarea)').click(function()
   {
      //gets triggered when a div is clicked
      $(this).children().show().focus().addClass("focus");
   });
});