@settlementType = (evt, id) ->
  settlement_content = document.getElementsByClassName('settlement_content')
  i = 0
  while ( i < settlement_content.length )
    settlement_content[i].style.display = 'none'
    i++
  tab_link = document.getElementsByClassName('tab_link')
  a = 0
  while ( a < tab_link.length )
    tab_link[a].className = tab_link[a].className.replace(' active', '')
    a++
  document.getElementById(id).style.display = 'block'
  evt.currentTarget.className += 'active'
  return