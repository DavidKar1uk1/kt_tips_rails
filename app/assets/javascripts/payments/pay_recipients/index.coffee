@shift_pay_recipient = ->
  recipient_choice = document.getElementById('recipient_choice')
  bank_recipient = document.getElementById('bank_recipient')
  mobile_recipient = document.getElementById('mobile_recipient')
  if recipient_choice.checked == true
    mobile_recipient.style.display = 'none'
    bank_recipient.style.display = 'block'
  else
    mobile_recipient.style.display = 'block'
    bank_recipient.style.display = 'none'
  return