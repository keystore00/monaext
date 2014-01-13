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

0. 2chブラウザにて`ツール->設定->機能->コマンド`
0. "コマンド名"に好きな名前を、"実行するコマンド"に次を入力
`"$BASEPATH\monaext\sendmona.bat" $TEXT`
0. 終了

使い方
---------------
0. 送金したいMonacoinアドレスを選択して右クリックし、設定した名前のコマンドを選択
0. 送金額を聞かれるので入力
0. パスフレーズを聞かれた場合は、パスフレーズを入力
0. 終了

追加
---------------
- コマンド追加時に
`"$BASEPATH\monaext\sendmona.bat" $TEXT 5`
のように指定することで、あらかじめ送金額を決めておくことも可能。
- param.batでのpassphraseの入力は任意。入力した場合、送金時のpassphraseの入力を省ける。

---
寄付MONA：MQY1eFCC2Mxa3sRyME5mNFUWc4wyWxJjtx