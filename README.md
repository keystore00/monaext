2ch Browser Extension for Monacoin
===============
2ch BrowserからMonacoinを送金するためのスクリプト。
Jane Style、JaneXenoでの動作確認済み。

設定方法
---------------
0. [クリックしてダウンロード](https://github.com/keystore00/monaext/archive/master.zip "Download")
0. ファイルを解凍し、フォルダ名をmonaextに変更
0. monaextフォルダを"Jane2ch.exe"と同じフォルダに配置
0. 次のうちどちらかを実行
    - monacoin.confを`%AppData%\Monacoin\monacoin.conf`に移動。
    - param.batをテキストエディタで開き各パラメータを`%AppData%\Monacoin\monacoin.conf`の値と同じに設定。(passphraseの入力は任意)
0. クライアントを再起動
0. 2chブラウザにて`ツール->設定->機能->コマンド`
0. "コマンド名"に好きな名前を、"実行するコマンド"に次を入力
`"$BASEPATH\monaext\SendTo.bat" $TEXT`
0. 終了

使い方
---------------
0. 送金したいMonacoinアドレスを選択した状態で右クリック、設定したコマンドを選択
0. 送金額を聞かれるので入力
0. パスフレーズを聞かれた場合は、パスフレーズを入力
0. 終了

追加
---------------
- コマンド追加時に
`"$BASEPATH\monaext\SendTo.bat" $TEXT 5`
のように指定することで、あらかじめ送金額を決めておくことも可能。
- param.batでのpassphraseの入力は任意。入力した場合、送金時のpassphraseの入力を省ける。
- FindAddress.batで送金者のアドレスがわかる。
- うまく送金者のアドレスが表示されないときは、設定ファイルに`txindex=1`を追加して再起動


SendMulti 複数のアドレスに一括送信（重複は無視されます）
===============
設定・使い方
---------------
0. パラメータ等を上記を参考に設定
0. 次の文字列をcommand.datに追記  
```
AddToList="$BASEPATH\monaext\AddToList.bat" $TEXT
SeeList="$BASEPATH\monaext\SeeList.bat"
EditList="$BASEPATH\monaext\EditList.bat"
SendMulti="$BASEPATH\monaext\SendMulti.bat"
ResetList="$BASEPATH\monaext\ResetList.bat"
```
0. アドレスを選択してAddToListでアドレスをリストに追加
0. SeeListでアドレスのリストを閲覧
0. EditListでアドレスのリストを編集
0. SendMultiで送信
0. ResetListでリストをリセット
0. 終了

---
Copyright (c) 2014 keystore00  
This software is released under the MIT License, see LICENSE.txt.  
寄付MONA：MQY1eFCC2Mxa3sRyME5mNFUWc4wyWxJjtx