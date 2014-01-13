Set argv = WScript.Arguments
userpass = argv(0)
ipport = argv(1)
address = argv(2)
amount = argv(3)

Dim passphrase
If argv.Count = 5 Then
  passphrase = argv(4)
Else
  passphrase = ""
End If

strScriptPath = Replace(WScript.ScriptFullName,WScript.ScriptName,"")
curl = strScriptPath & "curl.exe"
tmpFilename = strScriptPath & "tmp.txt"

CheckAddressValidity(address)
If amount = 0 Then
  amount = GetAmount()
End If
params = "[""""""" & address & """""""," & amount & "]"
jsonStr = SendCommand("sendtoaddress", params)
errMsg = GetErrorMsg(jsonStr)
If IsError(errMsg) Then
  'maybe passphrase error
  'send passphrase
  passphrase = GetPassphrase()
  new_params = "[""""""" & passphrase & """""""," & 1 & "]"
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

Function ReadOneLine(filename)
  Set objFileSys = CreateObject("Scripting.FileSystemObject")
  Set objTextStream = objFileSys.OpenTextFile(filename, 1)
  ReadOneLine = objTextStream.ReadLine
  objTextStream.Close
End Function

Function SendCommand(strMethod, strParams)
  prefix = " --data-binary ""{""""jsonrpc"""""":""""""1.0"""""",""""""method"""""":"""""""
  infix = """"""",""""""params"""""":"
  suffix = "} -H ""content-type: text/plain;"" "
  command = curl & " -o """  & tmpFilename & """ -u " & userpass & prefix & strMethod & infix & strParams & suffix & ipport
  Set WshShell = CreateObject("WScript.Shell")
  Set outExec = WshShell.Exec(command)
  Do While outExec.Status = 0
       WScript.Sleep 100
  Loop
  If outExec.ExitCode <> 0 Then
    MsgBox "Monacoin is not running", vbCritical, "Error"
    WScript.Quit
  End If
  SendCommand = ReadOneLine(tmpFilename)
  DeleteFile(tmpFilename)
End Function

Sub DeleteFile(filename)
  Set objFileSys = CreateObject("Scripting.FileSystemObject")
  objFileSys.DeleteFile filename, True
End Sub

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
  strAmount = InputBox("Amount","Input amount","1")
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