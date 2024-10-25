## git commands
git remote show origin
git -v : バージョン
git add .
git commit -m
git clone
git branch
git branch -d
git push
git switch
git pull
git fetch
git merge
git diff
git status
git mv
git show(git show HEADと同じ)

## git config
git config user.name
git config user.email
git config core.ui
git config core.editor
git config -l : コマンドを実行した箇所で有効になっている設定項目全て
git config -e : 設定ファイルをエディタで直接編集

git config --local <name>  : 全ユーザの全リポジトリ /etc/gitconfig
git config --global <name> : 該当ユーザの全リポジトリ ~/.gitconfig
git config --system <name> : 該当リポジトリ repository/.git/config

## git show options
git show HEAD
git show HEAD~1
git show HEAD~n(n個前のcommitを指定)

## git log options
-p : コミット時の変更内容
--stat 変更ファイル一覧
--oneline --graph
--since="2020/04/01" --until="2020/04/30"
--author="user"
--grep="fix"
--merges
--no-merges
