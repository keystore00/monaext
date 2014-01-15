Set argv = WScript.Arguments
rpcuser = argv(0)
rpcpass = argv(1)
ipport = argv(2)

txid = InputTXID()
raw_tx_id = GetResult(SendCommand("getrawtransaction","[""" & txid & """]"))
Dim raw_tx
If Not IsNull(ParseJson(SendCommand("decoderawtransaction","["""&raw_tx_id &"""]")).result) Then
  set raw_tx = ParseJson(SendCommand("decoderawtransaction","["""&raw_tx_id &"""]")).result
Else
  MsgBox "Cant find transaction: " & txid, vbCritical, "Error"
  WScript.Quit
End If
addresses = ""
For Each  input In raw_tx.vin
  tmp = ParseJson(SendCommand("getrawtransaction","[""" & input.txid & """]")).result
  If Not IsNull(ParseJson(SendCommand("decoderawtransaction","["""& tmp &"""]")).result) Then
    set input_raw_tx = ParseJson(SendCommand("decoderawtransaction","["""& tmp &"""]")).result
    set vout = JsonArrayAt (input_raw_tx.vout, input.vout)
    For Each address In vout.scriptPubKey.addresses
      addresses = addresses & vbCrLf & address & " " & vout.value
    Next
  End If
Next
MsgBox addresses, , "Sender address(es) is"

Function InputTXID()
  input = InputBox("Input Transaction ID","Transaction ID","")
  If Len(input) = 0 Then
    'cancel
    WScript.Quit
  End If
  If Len(input) <> 64 Then
    MsgBox "Invalid length transaction id: " & input, vbCritical, "Error"
    WScript.Quit
  Else
    InputTXID = input
  End If
End Function

