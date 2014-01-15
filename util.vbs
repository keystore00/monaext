Function JsonArrayAt(jsonArray, index)
  i = 0
  For Each elm In jsonArray
    If i = index Then
      Set JsonArrayAt = elm
      Exit For
    End If
    i = i+1
  Next
End Function

Function JsonArrayAtAsNonObj(jsonArray, index)
  i = 0
  For Each elm In jsonArray
    If i = index Then
      JsonArrayAtAsNonObj = elm
      Exit For
    End If
    i = i+1
  Next
End Function

Function IsError(errMsg)
  IsError = Len(errMsg) <> 0
End Function

Function ParseJson(jsonStr)
  Set objSC = CreateObject("ScriptControl")
  objSC.Language = "JScript"
  objSC.AddCode "function jsonParse(s) { return eval('(' + s + ')'); }"
  Set ParseJson = objSC.CodeObject.jsonParse(jsonStr)
End Function

Function GetResult(jsonStr)
  Set jsonObj = ParseJson(jsonStr)
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

Function InputAmount()
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

Function IsError(errMsg)
  IsError = Len(errMsg) <> 0
End Function

Function GetErrorMsg(jsonStr)
  Set jsonObj = ParseJson(jsonStr)
  If IsObject(jsonObj.error) then
    GetErrorMsg = jsonObj.error.message
  Else
    GetErrorMsg = ""
  End If
End Function
