@shift_pay = ->
  a = document.getElementById('pay_choice')
  pay_recipients = document.getElementById('pay_recipients')
  payments = document.getElementById('payments')
  if a.checked == true
    pay_recipients.style.display = 'none'
    payments.style.display = 'block'
  else
    pay_recipients.style.display = 'block'
    payments.style.display = 'none'
  return