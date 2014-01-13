Jane Style Extension for Monacoin
===============
Jane Styleから直接Monacoinを送金するためのスクリプトです。
設定方法
---------------
0. ページ右にある"Download　Zip"をクリックしてダウンロード
0. ファイルを解凍し、monaextフォルダを"Jane2ch.exe"と同じフォルダに配置
0. param.batをテキストエディタで開き各パラメータを"%AppData%\Monacoin\monacoin.conf"の値と同じに設定する。(passphraseの入力は任意)、（monacoin.confがないもしくは空の場合は、example.confをmonacoin.confにリネームして先ほどのフォルダに配置。この場合は、param.batは書き換える必要はない）
0. Jane Styleにてツール->設定->機能->コマンドに移動
0. コマンド名に好きな名前を、実行するコマンドに次を入力  "$BASEPATH\monaext\sendmona.bat" $TEXT
0. 終了

使い方
---------------
0. 送金したいMonacoinアドレスを選択して右クリックし設定した名前のコマンドを選択
0. 送金量を聞かれるので入力
0. パスフレーズを聞かれた場合は、パスフレーズを入力
0. 終了

寄付MONA：MQY1eFCC2Mxa3sRyME5mNFUWc4wyWxJjtx