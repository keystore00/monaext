Set argv = WScript.Arguments
rpcuser = argv(0)
rpcpass = argv(1)
ipport = argv(2)
filepath = argv(3)

Dim passphrase
If argv.Count = 5 Then
  passphrase = argv(4)
Else
  passphrase = ""
End If

Set dict = LoadAddressList(filepath)
amount = InputAmount()
addresses = Dict2Str(dict)
IsOk = MsgBox("Send " & amount & " MONA to following addresses." & addresses, vbOKCancel, "Really?")
If IsOK <> 1 Then
  MsgBox "Canceled", vbInformation, "Cancel"
  WScript.Quit(-1)
End If
addr_param = CreateSendMultiParam(dict,amount)

params = "[""""," & addr_param & "]"
jsonStr = SendCommand("sendmany", params)
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
  jsonStr = SendCommand("sendmany", params)
  errMsg = GetErrorMsg(jsonStr)
  If IsError(errMsg) Then
    MsgBox errMsg, vbCritical, "Error"
  End If
Else
  errMsg = GetErrorMsg(jsonStr)
  MsgBox errMsg, vbCritical, "Error"
  WScript.Quit
End If

Function LoadAddressList(filename)
  Set objFileSys = CreateObject("Scripting.FileSystemObject")
  Set objTextStream = objFileSys.OpenTextFile(filename, 1)

  Set dict = CreateObject("Scripting.Dictionary")
  Do Until objTextStream.AtEndOfLine = True
    strText = objTextStream.ReadLine
    If dict.Exists(strText) Then
      dict(strText) = dict(strText) + 1
    Else
      dict.Add strText, 1
    End If
  Loop
  objTextStream.Close
  Set LoadAddressList = dict
End Function

Function Dict2Str(dict)
  ret = ""
  For Each element In dict
    ret = ret & vbCrLf & element
  Next
  Dict2Str = ret
End Function

Function CreateSendMultiParam(dict,amount)
  ret = "{"
  For Each element In dict
    ret = ret & """" & element & """:" & amount & ","
  Next
  ret = Left(ret,Len(ret)-1) & "}"
  CreateSendMultiParam = ret
End Function

