## ECMA(エクマ)Script
JavaScriptの使用を定義したもの。
Ecmaインターナショナルが策定している。
ESは毎年6月に改定される。改訂される度にJavaScriptエンジン(JavaScriptCoreやV8)は
ESを実装することになる。

##  Module
Node.jsはECMAモジュール(ESM)とCommonJSの両方をサポートしている。
ESMはimport、CommonJSはrequireを使用する。
requireはファイルのどこにでも記述できる一方、importは必ずトップレベル(ブロックや関数の外)
に記述する必要がある。

スクリプト...普通のJavaScriptファイル。ただし、importとexportを含まない。

モジュール...importかexportを一つ以上含むファイル

## モジュールは常にStrictモード
よって、未定義の変数に代入はできない。
また、デフォルトで変数や関数は非公開になるので、他のモジュールから参照したい場合は
exportを先頭につける必要がある。

## モジュールはimport時に一度だけ評価される
三回読み込んだとしても評価されるのは最初の一回目のみ。

## CommonJSにおけるexport
export = dayjs;
という記述になる.
これはECMAScriptのdefault exportとは異なるため、
TypeScriptのコンパイラはデフォルトインポートを行うために特別なフラグ
（allowSyntheticDefaultImports）を必要とする.
