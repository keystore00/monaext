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
  InputAmount = amount
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
    MsgBox "Monacoin is not running or params are wrong", vbCritical, "Error"
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

Function GetErrorCode(jsonStr)
  Set jsonObj = ParseJson(jsonStr)
  If IsObject(jsonObj.error) then
    GetErrorCode = jsonObj.error.code
  Else
    GetErrorCode = 0
  End If
End Function

' Error code Definitions
RPC_NON_ERROR = 0
' General application defined errors
RPC_MISC_ERROR = -1 ' std::exception thrown in command handling
RPC_FORBIDDEN_BY_SAFE_MODE = -2 ' Server is in safe mode, and command is not allowed in safe mode
RPC_TYPE_ERROR = -3 ' Unexpected type was passed as parameter
RPC_INVALID_ADDRESS_OR_KEY = -5 ' Invalid address or key
RPC_OUT_OF_MEMORY = -7 ' Ran out of memory during operation
RPC_INVALID_PARAMETER = -8 ' Invalid, missing or duplicate parameter
RPC_DATABASE_ERROR = -20 ' Database error
RPC_DESERIALIZATION_ERROR = -22 ' Error parsing or validating structure in raw format

' P2P client errors
RPC_CLIENT_NOT_CONNECTED = -9 ' Bitcoin is not connected
RPC_CLIENT_IN_INITIAL_DOWNLOAD = -10 ' Still downloading initial blocks
RPC_CLIENT_NODE_ALREADY_ADDED = -23 ' Node is already added
RPC_CLIENT_NODE_NOT_ADDED = -24 ' Node has not been added before

' Wallet errors
RPC_WALLET_ERROR = -4 ' Unspecified problem with wallet (key not found etc.)
RPC_WALLET_INSUFFICIENT_FUNDS = -6 ' Not enough funds in wallet or account
RPC_WALLET_INVALID_ACCOUNT_NAME = -11 ' Invalid account name
RPC_WALLET_KEYPOOL_RAN_OUT = -12 ' Keypool ran out, call keypoolrefill first
RPC_WALLET_UNLOCK_NEEDED = -13 ' Enter the wallet passphrase with walletpassphrase first
RPC_WALLET_PASSPHRASE_INCORRECT = -14 ' The wallet passphrase entered was incorrect
RPC_WALLET_WRONG_ENC_STATE = -15 ' Command given in wrong wallet encryption state (encrypting an encrypted wallet etc.)
RPC_WALLET_ENCRYPTION_FAILED = -16 ' Failed to encrypt the wallet
RPC_WALLET_ALREADY_UNLOCKED = -17 ' Wallet is already unlocked

