# JavaScriptでテスト駆動開発に挑戦してみた

[テスト駆動JavaScript](http://www.amazon.co.jp/dp/4048707868)を一部読んだ感想と、
それで始めたJavaScriptのテスト駆動開発についてまとめた。

## テスト駆動JavaScriptの感想文（第三部まで）

[テスト駆動JavaScript](http://www.amazon.co.jp/dp/4048707868)を読んで、
とりあえずテストを書きながらプログラムの開発を進められるようになったので、
ここまでこの本を読んだ感想を記述する。

ただAjaxやNode.jsなどについては、僕がまだ触れていないので感想を記述しない。
この記事に記述がないからといって、
この本にそういったことへの言及がないというわけではないので注意。

### 第一章

とりあえず、さらっとテスト駆動開発とは何かを述べてる部分。
実際に適当な実装を考えて、テストを書く、合格させる。
といったものについて述べていた。

他には用語の説明などがざっと書いてあったので、
テスト駆動開発とは無縁の人生を歩んで来た僕にとっては、
基礎固め的な意味でいろいろ助かった感じ。

ここで、[JsTestDriver](http://code.google.com/p/js-test-driver/)というツールが紹介され、
この本のサンプルはこのツールの形式で書かれてゆく。
僕もインストールしてみたが、この本に反逆してHomebrewでインストールした。
`brew install js-test-driver`で`js-test-driver`コマンドが使えるようになる。

### 第二部

言語としてのJavaScriptについて取りあげている部分。
関数、クロージャー、継承、Mixinが主なテーマだった。

これはこの本の原著が書かれた時期のせいなのかもしれないが、
サイ本などでECMAScript第五版に慣れた僕にしては、
少々古いテクが登場していたように思える。
ただ、`Object.prototype.bind()`の説明は良かったかなと思う。

ただ、この章の最後にECMA Script第五版で追加される機能について説明しているので、
まあ問題はないと思う。

### 第三部

ここでは`Observer`というクラスの実装を通して、
テスト駆動開発をスタートする。
ここでは、テストを書いて合格させ、
次にまたテストを書いて……の作業によって物を作る。

さらにはこの後AjaxとNode.jsらへんにも言及しているが、
僕はこれらを使うアプリを書いたことがないし、
差し当たり必要でもないのでここまでで一区切りとした。

## 開発してみた

情報特別演習という授業でJavaScriptを使った物を作っている。
担当の先生にも、テスト駆動開発を勧められたので、
今まで書いた五百行くらいのコードにテストを書き始める。

### 環境の構築

テストはコンソールに文字が出るだけで味気ないので、
コードカバレッジを出力する[JsTestDriverのプラグイン](http://code.google.com/p/js-test-driver/downloads/detail?name=coverage-1.3.4.b.jar&can=2&q=)
を入れてみた。

ちなみに入れた時の僕はコードカバレッジが何なのか知らなかったが、
なんとなく格好よさそうなので入れることにした。

#### Code Coverage

[このサイト](http://d.hatena.ne.jp/hida_shun/20120328/1332946324)を参考に、
jarファイルを引っ張って来て、JsTestDriverの設定ファイルに書き込む。
さらに、[lcov](http://ltp.sourceforge.net/coverage/lcov.php)をインストールする。
僕は反逆者なので、またしてもHomebrewを使った。
`brew install lcov`で入る。

そして、confファイルを次のように指定。

*jsTestDriver.conf*

```yaml
server: http://localhost:4224

load:
  - lib/*.js
  - js/*.js

test:
  - t/src/*.js

plugin:
  - name: "coverage"
    jar: "plugin/coverage-1.3.4.b.jar"
    module: "com.google.jstestdriver.coverage.CoverageModule"
```

#### OMake

またコード書き変える度にコンソール開くのは面倒なので、
例によってOMakefileを書くところからはじめた。
まあ、そんなに面倒でもないと思っていたけど、
ソースとテストの入ったフォルダの中身全てのファイルについて、
変更監視をせねばならんので、結構だるそう。

まあ小説をLaTeXでコンパイルする時に使ったOMakeの設定を流用。

*OMakeroot*

```
DepsUpdate(dirs) = 
	deps = 
		foreach(dir, $(dirs))
			foreach(file, $(ls $(dir)))
				value $(file)
	
	return $(deps)

.SUBDIRS: .
```

*OMakefile*

```
dirs[] =
	js
	lib
	t/src

t/dat/jsTestDriver.conf-coverage.dat: $(DepsUpdate $(dirs))
	js-test-driver --tests all --captureConsole --testOutput t/dat/

t/result/index.html: t/dat/jsTestDriver.conf-coverage.dat
	genhtml -o t/result $<

.DEFAULT: t/result/index.html
```

`omake -P`としておけば、
`dirs`で登録したフォルダ中にあるファイルについて、
変更を見付け次第直ちにテストが自動実行される。

### 開発してみた感想

とりあえず、テストを書いてゆく。
まあ、ある程度出来てるものにテスト書くのだから、
結構サクサク進んだ。

それと、コードカバレッジがなかなか良く、
一度たりとも実行されていないコードが分かるというのは大きい。
この網羅率が百パーセントになるように、テストを足したり、
コードをリファクタリングしていく作業になった。

また、夜に作業してて続きは次の日、みたいな時にも、
明日はこのテストを通すところから始めよう、
みたいな感じで進捗を簡単に確認しながら開発出来るのもいい。

また、DOMについてはコメントに埋め込む形で記述出来るのもいい。
例えば、

```html
<html>
<body>
<div id="hoge">
	<p>foofoo</p>
</div>
</body>
</html>
```

というようなDOMがある前提で動作する部分もあると思う。
このような場合は、
`createElement`でちまちまノードを生成して、
`document.body`に`appendChild`するといった死ぬ程面倒な手法を取るか、
`document.body.innerHTML`にDOMを代入するといった邪悪な手法へ走るかという選択を迫られるように思える。

JsTestDriverは次のようにDOMを構築出来る。

```javascript
DOMTest.prototype["test exist element which has hoge id"] = function () {
	/*:DOM +=
		<div id="hoge">
			<p>foofoo</p>
		</div>
	*/

	assertNotUndefined( document.body.getElementById("hoge") );
};
```

このDOMは各テスト毎にクリアされるので、
結構捗る。
僕は今まで生のHTMLデータにその都度変更を加えてテストしていたので、
それに比べると飛躍的に楽。

## まとめ

テスト駆動JavaScriptはなかなかいい本だと思う。
テストを一ミリも書いたことがなくても、
普通にテスト駆動開発に入門出来る。
そもそも僕はテスト駆動開発には何が必要なのかも分かってなかったけど、
その辺から説明してくれていてありがたい。

そしてテスト駆動開発だけど。
たかだか五行程度のプログラムでも結構その便利さを感じるので、
大規模なものを書くなら十分ありだと思う。
ただ、最初からテスト駆動開発でゆけるかと言われると、
僕の中では少々微妙な気がする。
テストを書くというのは、暫定的な仕様を決めるって感じだと思う。
僕はコードを書きながら仕様を考える感じなので、
ある程度書いてからテストを書き始めるスタイルを取るんじゃないかなと思う。

