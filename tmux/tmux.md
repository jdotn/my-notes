## tmux

## Session operation
tmux : sessionの起動
tmux new -s 名前: 名前付きsessionを起動
tmux a: sessionの再開
tmux a -t 名前: 中断していた名前付きsessionに戻る 
prefix d: sessionの一時中断(Detach)
prefix s: sessionの表示
exit: sessionの終了

## Window operation
prefix c: 新規ウィンドウを作成
prefix n: 次のウィンドウに移動
prefix p: 前のウィンドウに移動
prefix w: windowの表示

## pain operation
prefix %: ペインを左右に分ける
prefix ": ペインを上下に分ける
prefix o: 次のペインに移動
prefix ;: 前のペインに移動
prefix x: ペインを終了
prefix {: ペイン順序を前方向に入れ替え
prefix {: ペイン順序を後方向に入れ替え
exit: ペインを終了

## other
prefix ?: キーバインドの一覧を表示
