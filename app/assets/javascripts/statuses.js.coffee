# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".email-share").click ->
    swal
      title: "Share this playlist!"
      text: "Type users email to send him this playlist details:"
      type: "input"
      showCancelButton: true
      closeOnConfirm: false
      animation: "slide-from-top"
    , (inputValue) ->
      return false  if inputValue is false
      if inputValue is ""
        swal.showInputError "You need to write an email address!"
        return false

      $.ajax
        url: "/share_status/" + $("#main").data("id")
        type: "POST"
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        data: inputValue
        success: (response) ->
          swal "Nice!", "This playlist details will be sent to: " + inputValue + ". \n Thank You for using spotihunt.com!", "success"
          
  $('.status').hover (event) -> 
    $(this).toggleClass("hover")
