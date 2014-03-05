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

params = "[""" & address & """," & amount & "]"
jsonStr = SendCommand("sendtoaddress", params)
errCode = GetErrorCode(jsonStr)
If errCode = RPC_NON_ERROR Then
  WScript.Quit
End If
'Handle error
If errCode = RPC_WALLET_UNLOCK_NEEDED Then
  'passphrase error
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
Else
  errMsg = GetErrorMsg(jsonStr)
  MsgBox errMsg, vbCritical, "Error"
  WScript.Quit
End If
