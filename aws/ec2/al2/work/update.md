### Amazon LinuxのPHP 7.4 -> 8.2実施手順

2024年9月26日(木)11:00のアップデート業務手順.


PHPのバージョンが7.4であることを確認。

```bash
php -v
```

パッケージのアップデート

```bash
sudo yum update -y
```

php7.4の無効化

```bash
sudo amazon-linux-extras disable php7.4
```

サーバーソフトウェアの停止

```bash
sudo systemctl stop httpd.service
```
```bash
sudo systemctl stop php-fpm.service
```

すべてのPHPライブラリの削除

```bash
sudo yum -y remove php-cli php-common php-fpm php-json php-mbstring php-mysqlnd php-opcache php-pdo php-pecl-igbinary php-pecl-redis php-pgsql php-xml
```

PHPライブラリがすべて削除されたか確認

```bash
sudo yum list installed | grep php
```

php8.2の有効化(phpのインストールではない)

```bash
sudo amazon-linux-extras enable php8.2
```

パッケージに関するメタデータの削除。※Amazon Linuxから実行するよう指示が出る。

```bash
sudo yum clean metadata
```

PHPライブラリのインストール

```bash
sudo yum install php-cli php-common php-fpm php-json php-mbstring php-opcache php-pgsql php-xml
```

PHPのバージョンが8.2になっていることを確認

```bash
php -v
```

php-pearのインストールによりpeclコマンドが使える(一緒にphp-processというのもインストールされる)

```bash
sudo yum install php-pear
```
peclでredisをインストールするときにphp-develが求められるのでインストール.

```bash
sudo yum install php-devel
```
redisのインストール※gccが入っていない場合はyum install gcc

```bash
sudo pecl install redis
```
igbinaryのインストール

```bash
sudo pecl install igbinary
```
 igbinaryの有効化 ※/etc/php.d/40-igbinary.iniを作成し、下記を記載

```
[igbinary]
extension=igbinary.so
```
redis.soの有効化 ※/etc/php.d/50-redis.iniを作成し、下記を記載

```
extension=redis.so
```
必要となるPHPがすべてインストールされており、有効になっているか確認

```bash
yum list installed | grep php
```
```
php -m
```
ソースのデプロイ完了後、Webサーバーソフトウェアの起動

```bash
sudo systemctl start httpd.service
```
```bash
sudo systemctl start php-fpm.service
```
#php-fpm...FastCGIプロトコルを介してWebサーバー(apache)と通信しphpの処理を行う
プロセスマネージャー。

問題なくphp8.2, phpライブラリがインストールできた場合はgeonavi2-web-dev2も同様の手順でphp8.2にする。

EC2のphpをアップデートする（amazon-linux-extrasコマンド）: [https://namileriblog.com/aws/amazon-linux-extras/#i-10](https://namileriblog.com/aws/amazon-linux-extras/#i-10) 
