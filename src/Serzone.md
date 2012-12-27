# Serzone.js

## 概要

プレゼンテーションフレームワークです。
HTMLとCSS、それにJavaScriptを使ってヌルヌル動くプレゼンテーションの作成を支援するツールです。

## 経緯

この世の中に僕が求めるプレゼンテーションフレームワークが存在しなかったので、
いつか作ろうと思っていました。

僕のいる大学では情報特別演習といって、適当な物体を開発するなど思い思いのことをして
単位が貰えるという講義があるので、
それに乗っかって作りました。

## デモ

Chromeでしか動かないのですが、[こちら](http://yoshimurayuu.github.com/Serzone/)を見てください。

## 使い方

上のスライドを見て、使ってみようと思った方に、簡単な使い方を用意しておきます。

### セットアップ

Githubのみで公開しているので、Gitを用意するのが楽でしょう。
また、現在はまだ安定板ではないので`tc`ブランチをクローンしてください。

```
git clone git://github.com/yoshimuraYuu/Serzone.git
```

として、ダウンロードします。
その上で、 _Serzone_ フォルダへ移動します。

```
cd Serzone
```

### プレゼンテーションを作る

_Serzone_ フォルダの直下に次のようなHTMLファイルを作ります。

```html
<html lang="jp">
<head>
    <meta charset="utf-8" />
    <title>Serzone.js</title>
    
	<link rel="stylesheet" href="http://yandex.st/highlightjs/7.3/styles/default.min.css">
	<script src="http://yandex.st/highlightjs/7.3/highlight.min.js"></script> 
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
	<script src="http://ricostacruz.com/jquery.transit/jquery.transit.min.js"></script>

	<link rel="stylesheet" href="css/abilify.css"/>
	<script src="js/abilify.js"></script>
	<script src="js/Serzone.js"></script>
</head>

<body>
<script>
</script>

<div id="serzone">

ここが編集する領域です。

</div>

<script>
	Serzone.start();
</script>

</body>
</html>
```

編集領域に次のようなタグを貼ってみます。

```html
<section>
	<h1>最初</h1>

	<appear><p>ほげ</p></appear>

	<summary>
		<p>ほげげげ</p>
	</summary>
</section>

<section>
	<h1>二個目</h1>

	<p>ふが</p>
	<section>
		<h1>入れ子1</h1>

		<p>入れ子1</p>
		<summary>
			<p>入れ子1こここ</p>
		</summary>
	</section>

	<section>
		<h1>入れ子2</h1>

		<p>入れ子2</p>
		<summary>
			<p>入れ子2こここ</p>
		</summary>
	</section>

	<summary>
		<p>ふががが</p>
	</summary>
</section>
```

このファイルは`tc`ブランチ直下の _index.html_ と同じです。
この結果は[こんな感じ](http://yoshimurayuu.github.com/Serzone/demo.html)になります。

### デフォルトで使える特殊タグ

これらは _js/abilify.js_ に収録されているものです。

#### `<section>`

スライドの開始を現わします。

#### `<appear>`

中身を出現させます

#### `<src>`

中身に`<pre><code>`で囲われたエレメントを取り、
ソースコードをハイライトします。

#### `<mark>`

`<mark t=" _target_ ">`が出現した時に、
`<m t=" _target_ ">`で囲われたオブジェクトの文字を強調します。

