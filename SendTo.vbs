Set argv = WScript.Arguments
rpcuser = argv(0)
rpcpass = argv(1)
ipport = argv(2)
address = argv(3)
amount = argv(4)

Dim passphrase
If argv.Count = 6 Then
  passphrase = argv(5)
Else
  passphrase = ""
End If

CheckAddressValidity(address)
If amount = 0 Then
  amount = InputAmount()
End If

params = "[""" & address & """," & amount & "]"
jsonStr = SendCommand("sendtoaddress", params)
errMsg = GetErrorMsg(jsonStr)
If IsError(errMsg) Then
  'maybe passphrase error
  'send passphrase
  passphrase = GetPassphrase()
  new_params = "[""" & passphrase & """,1]"
  jsonStr = SendCommand("walletpassphrase", new_params)
  errMsg = GetErrorMsg(jsonStr)
  If IsError(errMsg) Then
    MsgBox errMsg, vbCritical, "Error"
    WScript.Quit
  End If
  jsonStr = SendCommand("sendtoaddress", params)
  errMsg = GetErrorMsg(jsonStr)
  If IsError(errMsg) Then
    MsgBox errMsg, vbCritical, "Error"
  End If
End If
