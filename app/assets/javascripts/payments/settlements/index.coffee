@shift_settlement_account = ->
  account_choice = document.getElementById('account_choice')
  bank_accounts = document.getElementById('bank_accounts')
  mobile_wallets = document.getElementById('mobile_wallets')
  if account_choice.checked == true
    mobile_wallets.style.display = 'none'
    bank_accounts.style.display = 'block'
  else
    mobile_wallets.style.display = 'block'
    bank_accounts.style.display = 'none'
  return