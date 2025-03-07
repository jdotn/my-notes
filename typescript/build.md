# JavaScript TypeScriptのビルド

## esbuild
Goで実装された高速のJavaScriptバンドラーおよびミニファイア.
TypeScriptを早くコンパイルすることもできる.
TreeShakingと呼ばれる最適化手法を採用しており、
バンドル対象のコードを解析し、使用されていない不要なコードを
自動的に削除する.
ビルドプロセスを大幅に改善している.
ES6モジュールおよびCommonJsモジュールの両方に対応している.

## Webpack
JavaScriptで実装されたJavaScriptバンドラ.
デフォルトではCommonJSを使用しているため、
ESMを使用する際はBabelなどのトランスコンパイラが必要.


## tscとesbuildは違う
共にTypeScriptをJavaScriptにトランスコンパイルする
ツールだが、型チェックを行うか否か、バンドルを行うか否か
といった違いがある。

## バンドラであるesbuildはtsconfig.tsがいらない?
のかもしれない?

## Angularではesbuildを使用する場合もtsconfigを用いている?
angular.jsonファイルにtsConfigプロパティが存在し、
そこにtsconfigへのパスが記載してある。

## 型定義ファイルを出力するならtsc -dを使おう
esbuildでは型定義ファイルを作成できないため、npmパッケージを
公開するのであればtscを用いて型定義ファイルを作ろう。

## jsファイルをnodeで実行するとき
jsファイルをcommonjsとesmのどちらで実行するかをnodeに伝える
ため、package.jsonに"type":"module"を追加するか、
index.jsをindex.mjsにする必要がある?
package.jsonに"type": "module"を設定することで、.jsファイルが
.mjs(ESMのファイル)として認識されるらしい。
上記の設定をしない場合はファイルの拡張子を.mjsにすればよい。

