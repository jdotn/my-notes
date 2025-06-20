# Laravel アップグレード

## Laravel 6 -> 10への移行
2024年5月~9月にかけて, 業務で使用しているアプリケーションのLaravelアップデートを実施.

bitbucket-pipelines.ymlの修正

```yml
+ export COMPOSER_ALLOW_SUPERUSER=1
```

'1'を設定するとroot権限でのcomposer installを許可する。

```yml
+ composer install --prefer-dist --optimize-autoloader --no-interaction
```

composer installにおけるオプション。「インタラクティブな質問の問い合わせを行わない」とある.対話型のメッセージを表示しないためのオプション。

src/laravel/app/CustomLogger.phpの修正

```php
- use Monolog\Logger;
+ use Monolog\LogRecord;
```

Laravel9 -> 10のアップグレードで必要。LaravelのMonologがMonolog3.xに依存しているため、それに伴う修正。
https://laravel.com/docs/10.x/upgrade#monolog-3 
Monologのアップグレードガイドを参照し、修正を実施する必要がある。
https://github.com/Seldaek/monolog/blob/main/UPGRADE.md 

```php
- (array $record): array
+ (LogRecord $record): LogRecord
```

Log recordsのデータ型が配列(array)からMonolog\LogRecordオブジェクトに変更されているため修正。

Monolog\Loggerはこのファイルで使われていないが、関数の引数の型を記述するため消す必要はなかったかもしれない。
(Loggerクラスは既存のログレベルを拡張したいときに継承し、メソッドをオーバーライドをすることで実現できる)

```php
- $record['extra']['userid'] = $user->user_id ?? null;
+ $record->extra['userid'] = $user->user_id ?? null;

- $record['extra']['un'] = $user->name ?? null;
+ $record->extra['un'] = $user->name ?? null;
```

PHPにおいて、コールバック関数やメソッドを指定するとき[$this, 'methodName']のような配列形式が使われる。
第一引数にはオブジェクトまたはクラス名。
第二引数にはメソッド名または関数名。

Monolog2.xにおけるMonolog\Logger.phpのpushProccessor関数は引数にcallable型を取る。

```php
/**
Adds a processor on to the stack.
*/
public function pushProcessor(callable $callback): self
{
array_unshift($this->processors, $callback);

 return $this;
}
```

対して、Monolog3.xにおけるpushProccessor関数は引数にProccesorInterfaceまたはcallable(LogRecord)型を取るようになっている。

```php
/**
Adds a processor on to the stack.@phpstan-param ProcessorInterface|(callable(LogRecord): LogRecord) $callback@return $this
*/
public function pushProcessor(ProcessorInterface|callable $callback): self
{
array_unshift($this->processors, $callback);

 return $this;
}
```

そして、geonavi-web上でpushProcessor関数の引数には([$this, 'addExtraFields'])が指定されており、
コールバック関数として指定されているaddExtraFiedldsの引数は(array $record)とarrayを受け取る実装になっている。

Monolog3.xはaddExtraFields(LogRecord)として呼び出されるようになっているため、

```php
- public function addExtraFields(array $record): array
+ public function addExtraFields(LogRecord $record): LogRecord
```

とする必要があった。
```
FormatterInterface, HandlerInterface, ProcessorInterface, etc. changed to contain LogRecord $record instead of array $record parameter types.
```

(FormatterInterface, HandlerInterface, ProcessorInterfaceなどはarray型の$recordに代わり, LogRecord型の$recordを含むよう変更になった)とあるように、
$handler(HandlerInterface)が持つ$recordはLogRecord型になっている.

src/laravel/app/Exceptons/Handler.phpの修正

```php
- Exception;
+ Throwable;
```

Laravel6->7にかけて、App\Exceptions\Handlerクラスのreport, render, shouldReport, renderForConsoleメソッドは、Exceptionインスタンスに代えThrowableインターフェースの
インスタンスを受け取る必要があるため修正。

src/laravel/app/Http/Controllers/AreaController.phpの修正

```php
- $response = $areaService->detail($area_id);
+ $response = $this->areaService->detail($area_id);
```

コンストラクタの中で定義されたインスタンス変数にも関わらず,$thisが抜けていたので追加.

src/laravel/app/Http/Controllers/MailController.phpの修正

```php
$split = explode(':', $d);
$split = explode(':', $d ?? '');
```

php8.1からexplodeの第二引数がnullになり得るときWarningが出るようになったため、修正.
https://stackoverflow.com/questions/71097927/php-8-1-explode-passing-null-to-parameter-2-string-of-type-string-is-de 

phpにおける??(Null合体演算子)...第一オペランドが非nullの値であればそれを返し、そうでない場合は第二オペランドを返す.
[存在チェックの対象かつ存在した場合] ?? [存在しなかった場合]
https://www.php.net/manual/ja/language.operators.comparison.php#language.operators.comparison.coalesce 

explode(string $separator, string $string, int $limit = PHP_INT_MAX): array
文字列を文字列により分割する.
文字列の配列を返します。この配列の各要素は、 string を文字列 separator で区切った部分文字列となります。
https://www.php.net/manual/ja/function.explode.php 

src/laravel/composer.jsonの修正

```php
- "fzaninotto/faker": "~1.4",
+ "fakerphp/faker": "^1.9.1",
```

fzaninotto/fakerはphp8に対応していないため、代替となるfakerphp/fakerを利用する必要がある.

```yml
"autoload": {   
   "classmap": ["database"],
   "psr-4": {"App\\\\": "app/"
   "App\\\\": "app/",
   "Database\\\\Factories\\\\": "database/factories/",
   "Database\\\\Seeders\\\\": "database/seeders/"
  }
```

Laravel7->8にかけて、シーダとファクトリが名前空間になった。これに対応するにはDatabase\Seeders名前空間をシードクラスに追加する必要がある。
さらに、database/seedsディレクトリの名前をdatabase/seedersにリネームする必要がある。
ファクトリも同様に,ファクトリクラスに対しDatabase\Factories名前空間を追加する必要がある。
最後に、composer.jsonファイルのautoloadセクションからclassmapブロックを削除し、新しい名前空間クラス・ディレクトリマッピングを追加する。
https://readouble.com/laravel/8.x/ja/upgrade.html 

src/laravel/config/database.phpの修正

```php
- 'schema' => 'public',
+ 'search_path' => 'public',
```

Laravel8->9にかけて、Postgres接続検索パスを設定するために使用するschema設定オプションの名前をsearch_pathへ変更する必要がある.
https://readouble.com/laravel/9.x/ja/upgrade.html 

src/laravel/config/session_sandbox.phpの修正

```php
- 'secure' => false,
+ 'secure' => null,
```

Laravel6->7にかけて、session設定ファイルのsecureオプションをフォールバック値のnullへ変更する必要がある.
https://readouble.com/laravel/7.x/ja/upgrade.html 

src/laravel/routes/api.phpの修正

```php
Route::post('login', 'Auth\LoginController@authenticate');
Route::post('login', [LoginController::class, 'authenticate']);
```

Laravel7->8にかけて、ルートの記述方法が変わったため修正。

src/laravel/tests/Feature/BuildingAPI/UpdateTest.phpの修正

```php
- $geom = "ST_GeomFromText('POINT(${lat} ${lng})', 4326)";
+ $geom = "ST_GeomFromText('POINT({$lat} {$lng})', 4326)";
```

php8.2で推奨されなくなった記述のため修正。
PHP8.2の新機能: [https://kinsta.com/jp/blog/php-8-2/#h-13](https://kinsta.com/jp/blog/php-8-2/#h-13)

## Laravel 10 -> 11
1. まずはcomposer.jsonのrequireプロパティのバリューとなるオブジェクト内にある
laravel/frameworkを"^11.0.0"に変更。

2. composer updateを実施。

3. php artisan -Vでlaravelのバージョンが11になっているか確認。

4. 確認しようとしたところ、Cannot redeclare static Illuminate\Database\Eloquent\Model::$builder as non static
App\Models\Organizations::$builder
という謎のエラーが出てきた。

5. おそらくOrganizationクラスの親クラスであるModelクラス内の$builderがstaticであり、そのサブクラスで非staticとして
再定義しているためエラーを吐いている。

6. 実際にGitHub上のコードでLaravel10と11で比較したところ、framework/src/illuminate/Database/Eloquent/Model.php内に
protected static string $builder = Builder::class;
が追加されており、$builderが確かにstatic(かつstring型)になっていることが確認できる。

7. laravel/app/Models/Organization.phpの28行目。
protected $builderをprotected static string $builderに修正。

8. laravel/vendor/bin/phpunitでユニットテストを実施したところ、以下のエラーが出力。

1) Tests\Unit\Services\EventServiceTest::testCalcPeriodPassedDateに10dを与えた時の返り値が指定した期間になっていることを確認
TypeError: Carbon\Carbon::rawAddUnit(): Argument #3 ($value) must be of type int|float, string given, called in /var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php on line 356

/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:455
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:356
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2903
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2594
/var/www/html/laravel/app/Services/EventService.php:328
/var/www/html/laravel/tests/Unit/Services/EventServiceTest.php:134

2) Tests\Unit\Services\EventServiceTest::testCalcPeriodPassedDateに1dを与えた時の返り値が指定した期間になっていることを確認
TypeError: Carbon\Carbon::rawAddUnit(): Argument #3 ($value) must be of type int|float, string given, called in /var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php on line 356

/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:455
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:356
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2903
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2594
/var/www/html/laravel/app/Services/EventService.php:328
/var/www/html/laravel/tests/Unit/Services/EventServiceTest.php:151

3) Tests\Unit\Services\EventServiceTest::testCalcPeriodPassedDateに12hを与えた時の返り値が指定した期間になっていることを確認
TypeError: Carbon\Carbon::rawAddUnit(): Argument #3 ($value) must be of type int|float, string given, called in /var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php on line 356

/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:455
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:356
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2903
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2594
/var/www/html/laravel/app/Services/EventService.php:331
/var/www/html/laravel/tests/Unit/Services/EventServiceTest.php:168

4) Tests\Unit\Services\EventServiceTest::testCalcPeriodPassedDateに6hを与えた時の返り値が指定した期間になっていることを確認
TypeError: Carbon\Carbon::rawAddUnit(): Argument #3 ($value) must be of type int|float, string given, called in /var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php on line 356

/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:455
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:356
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2903
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2594
/var/www/html/laravel/app/Services/EventService.php:331
/var/www/html/laravel/tests/Unit/Services/EventServiceTest.php:185

5) Tests\Unit\Services\EventServiceTest::testCalcPeriodPassedDateに1hを与えた時の返り値が指定した期間になっていることを確認
TypeError: Carbon\Carbon::rawAddUnit(): Argument #3 ($value) must be of type int|float, string given, called in /var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php on line 356

/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:455
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Units.php:356
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2903
/var/www/html/laravel/vendor/nesbot/carbon/src/Carbon/Traits/Date.php:2594
/var/www/html/laravel/app/Services/EventService.php:331
/var/www/html/laravel/tests/Unit/Services/EventServiceTest.php:202

原因はメソッドの引数に新しく使用されているunion型には、 指定された型しか使用できないため。(それ以外の型に自動変換ができない)
Laravel10ではCarbon.phpのaddDays(), addHours()の引数はint型のみだったが、
Laravel11からはint|floatのunion型になっている。
PHP8.0から導入されたunion型(ここではint|float)にそれ以外の方を
代入しようとするとTypeErrorとなる処理となっている。

Carbon ver2 https://github.com/briannesbitt/Carbon/blob/2.73.0/src/Carbon/Carbon.php
Carbon ver3 https://github.com/briannesbitt/Carbon/blob/3.8.6/src/Carbon/Carbon.php
PHP https://www.php.cn/ja/faq/62045.html
