# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@selectPayType = (evt, id) ->
  zetabcontent = document.getElementsByClassName('ze_tab_content')
  i = 0
  while ( i < zetabcontent.length )
    zetabcontent[i].style.display = 'none'
    i++
  zetablinks = document.getElementsByClassName('ze_tab_links')
  a = 0
  while ( a < zetablinks.length )
    zetablinks[a].className = zetablinks[a].className.replace(' active', '')
    a++
  document.getElementById(id).style.display = 'block'
  evt.currentTarget.className += 'active'
  return
