$(document).ready(function()
{
   $('table#timetable td:has(textarea)').click(function(){
      $('table#timetable td:has(textarea)').not(this).each(function(i,element){
         if ($(element).find('input').val().length!=0 || $(element).find('textarea').val().length!=0)
            $(element).addClass('unfocused');
         else
            $(element).addClass('hidden');
      });
      if ($(this).hasClass('hidden'))
      {
         $(this).removeClass('hidden').removeClass('unfocused');
         $(this).find('input').focus();
      } else 
      {
         $(this).removeClass('hidden').removeClass('unfocused');
      }
   });
   $('table#timetable td textarea').focus(function(){
      $(this).parent().removeClass('unfocused').removeClass('hidden');
      $('table#timetable td:has(textarea)').not($(this).parent()).each(function(i,element){
         if ($(element).find('input').val().length!=0 || $(element).find('textarea').val().length!=0)
            $(element).addClass('unfocused');
         else
            $(element).addClass('hidden');
      });
   });
   $('table#timetable td input').focus(function(){
      $(this).parent().parent().removeClass('unfocused').removeClass('hidden');
      $('table#timetable td:has(textarea)').not($(this).parent().parent()).each(function(i,element){
         if ($(element).find('input').val().length!=0 || $(element).find('textarea').val().length!=0)
            $(element).addClass('unfocused');
         else
            $(element).addClass('hidden');
      });
   });
   
   $('table#timetable td:has(textarea)').each(function (i, element){
      if ($(element).find('input').val().length!=0 || $(element).find('textarea').val().length!=0)
            $(element).addClass('unfocused');
         else
            $(element).addClass('hidden');
   });
});