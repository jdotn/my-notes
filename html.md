private...ソフトプライベート
#...ハードプライベート

Renderer2 @angular/core
クラス.

## HTMLAnchorElement
このインタフェースはハイパーリンクElementを表し、
そのようなElementのレイアウトと表示を操作するための
特別なプロパティとメソッドを提供できるぞ.
このインタフェースは<a>Elementに対応しているぞ.
詳細は以下
https://developer.mozilla.org/ja/docs/Web/API/HTMLAnchorElement

HTMLAnchorElemtnt.download
文字列でリンク先リソースをブラウザに表示するのではなく、
ダウンロードすることを意図するためのプロパティ.
これに文字列を設定すると,ダウンロードするファイル名になるぞ.

HTMLAnchorElement.href
文字列化プロパティ.
URL全体を含む文字列を返すぞ.
HTMLのhref Atributeを反映するぞ.

## windowインタフェース
### window.window
windowオブジェクトのwindowプロパティはそのwindowオブジェクト自体を指す.
つまり、window.window.windowだろうが、同じオブジェクトを指す.
また、webページにおいてwindowオブジェクトはグローバルオブジェクトだ.

1. スクリプト中の変数globalは、実際にはwindowオブジェクトのプロパティである
var global = { daa: 0};
alert(global === window.global); //true

2. ブラウジングコンテキストにおいてwindowは最上位オブジェクトであるため、
windowオブジェクトのメンバへのアクセス時にはwindow接頭辞を省略することが
可能である.

##3 window.setTimeout("window.alert('Hi'), 50");
setTimeout("alert('Hi')", 50); //上と同じ


## URLインタフェース
URLの解釈、構築、正規化、エンコードに使用するぞ。

## 静的メソッド
### createObjectURL(object)
URLインタフェースの静的メソッドで、引数で指定された
オブジェクトを表すURLを含む文字列を生成してくれるぞ.
オブジェクトを開放するにはrevokeobjectURL()を呼び出すんだ.
既にobject URLが生成されていてもcreateObjectURL()は呼び出す
度に新しいobject URLを生成するから、メモリを解放するため
必要なくなったら明示的に開放するべきだ.ちなみにブラウザーが
アンロードされると、このobject URLはメモリから解放される仕組みに
なっているらしいぞ.

### 引数
object
オブジェクトのURLを生成するためのFile、Blob、MediaSourceのいずれかだぞ.
### 戻値
objectで指定された内容を参照するために使用されるオブジェクトURLの入った
文字列だぞ.

## Blob
Blobインタフェースはblob、すなわち不変の生データであるファイルのような
オブジェクトを表すぞ.テキストやバイナリとして読み込んだり、ReadableStream
に変換してそのメソッドを使ったデータ処理をしたりできるぞ.
また、Blobが表現することのできるデータは必ずしもJavascriptネイティブ形式
である必要はないぞ.
Blob以外のオブジェクトやデータからBlobを生成するならBlob()コンストラクタ
を使え.
### Blob.size(readonly)
Blobオブジェクトに含まれるデータサイズ(bites)だ.
### Blob.type(readonly)
Blobに含まれるデータのMIMEタイプを示す文字列だぞ.
タイプが不明ならこの文字列は空だぞ.
## Constructor
### new Blob(blobParts)
### new Blob(blobParts, options)
blobParts
反復可能なオブジェクト.例えばArrayとかだ.
その中身がArrayBuffer, TypeArray, Dataview, Blob, stringなどのオブジェクト.
それらがBlobの中に入れられるわけだ.
ただし、文字列は正規化されたUnicodeでなければならない.
optionsは、さっき書いたtypeとendingsだぞ.

## document
documentインタフェースはブラウザに読み込まれたウェブページを表し、
DOMツリーであるwebページのコンテンツへの入り口だ.
documentインタフェースは、あらゆる種類の文書に対して共通のプロパティや
メソッドを提供するぞ.また、文書の種類(HTML,XML,SVG)などに応じてより大規模な
APIを使用できるぞ.
コンテンツタイプ"text/html"で提供されるHTML文書では、HTMLDocumentインタフェース
も実装するぞ.
window.documentはウィンドウに含まれる文書への参照を返すぞ.

EventTarget <- Node <- Document

## document.body
bodyプロパティは現在の文書の<body>または<frameset>ノードを表し、そのような
要素がなければnullになるぞ.
つまり
<body>
<frameset>
null
のいずれかだ.

## パスワードの入力で表示非表示はどのような挙動?
input要素のtypeプロパティにpasswordを設定したとき非表示になる。
表示したいときはtypeプロパティをtextに変更する動作にすればよい。


