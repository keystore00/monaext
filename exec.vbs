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
  amount = GetAmount()
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

Function IsError(errMsg)
  IsError = Len(errMsg) <> 0
End Function
Function GetErrorMsg(jsonStr)
  Set objSC = CreateObject("ScriptControl")
  objSC.Language = "JScript"
  objSC.AddCode "function jsonParse(s) { return eval('(' + s + ')'); }"
  Set jsonObj = objSC.CodeObject.jsonParse(jsonStr)
  If IsObject(jsonObj.error) then
    GetErrorMsg = jsonObj.error.message
  Else
    GetErrorMsg = ""
  End If
End Function

Function GetResult(jsonStr)
  Set objSC = CreateObject("ScriptControl")
  objSC.Language = "JScript"
  objSC.AddCode "function jsonParse(s) { return eval('(' + s + ')'); }"
  Set jsonObj = objSC.CodeObject.jsonParse(jsonStr)
  GetResult = jsonObj.result
End Function

Sub CheckAddressValidity(address)
  If Len(address) <> 34 Then
    MsgBox "Invalid length Monacoin address: " & address, vbCritical, "Error"
    WScript.Quit
  End If
  If Left(address,1) <> "M" Then
    MsgBox "Invalid initial for Monacoin address: " & address, vbCritical, "Error"
    WScript.Quit
  End If
End Sub

Function GetAmount()
  jsonStr = SendCommand("getbalance","[]")
  balance = GetResult(jsonStr)
  strAmount = InputBox(balance & " MONA available","Input amount","1")
  If Len(strAmount) = 0 Then
    'cancel
    WScript.Quit
  End If
  amount = CDbl(strAmount)
  If Not IsNumeric(amount) Then
    MsgBox "Invalid input: " & strAmount, vbCritical, "Error"
    WScript.Quit
  End If
  GetAmount = amount
End Function

Function GetPassphrase()
  'passphrase param is set or not
  If Len(passphrase) <> 0 Then
    GetPassphrase = passphrase
  Else
    input = InputBox("Passphrase","Input passphrase","")
    If Len(input) = 0 Then
      'cancel
      WScript.Quit
    Else
      GetPassphrase = input
    End If
  End If
End Function

Function SendCommand(strMethod, strParams)
  Set oWinHttpReq = CreateObject("WinHttp.WinHttpRequest.5.1")
  URL = "http://" & ipport
  strJson = "{""method"":""" & strMethod & """,""params"":" & strParams & "}:"
  On Error Resume Next
  oWinHttpReq.Open "POST", URL, false
  oWinHttpReq.SetCredentials rpcuser,rpcpass,0
  oWinHttpReq.SetRequestHeader "Content-Type", "application/json-rpc"
  oWinHttpReq.Send(strJson)
  If Err.Number <> 0 Then
    MsgBox "Monacoin is not running", vbCritical, "Error"
    WScript.Quit
  End If
  SendCommand = oWinHttpReq.ResponseText
  On Error Goto 0
End Function