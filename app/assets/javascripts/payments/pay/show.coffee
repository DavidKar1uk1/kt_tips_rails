#@check_checkbox = ->
#  x = document.getElementById('target_destination')
#  a = document.getElementById('destination')
#  if a.checked == true
#    x.style.display = 'block'
#  else
#    x.style.display = 'none'
#  return

@orderType = (evt, id) ->
  pay_content = document.getElementsByClassName('pay_content')
  order_type = document.getElementById('order_type')
  i = 0
  while ( i < pay_content.length )
    pay_content[i].style.display = 'none'
    i++
  tab_link = document.getElementsByClassName('tab_link')
  a = 0
  while ( a < tab_link.length )
    tab_link[a].className = tab_link[a].className.replace(' active', '')
    a++
  document.getElementById(id).style.display = 'block'
  evt.currentTarget.className += 'active'
  return