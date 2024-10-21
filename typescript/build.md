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
