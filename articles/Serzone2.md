# Serzone.js -スタイルファイルの作り方-


Serzone.jsは、スライドの遷移など、任意のHTMLタグに任意のアニメーションを与えることが出来ます。ただ、このやり方を今迄全く説明していなかったので、がんばって説明してみようかと思います。

## はじめに


まず、リポジトリに用意されている _demo.html_ を見てみましょう。冒頭は次のように始まっています。

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
```


この中で、アニメーションを定義しているスタイルファイルは、 _abilify.css_ と _abilify.js_ です。ただ、CSSはあくまで単なるCSSですので、ここで重要なのはJavaScriptで定義されている、 _abilify.js_ かと思います。

この _abilify.js_ を一応見てみましょう。

```javascript
var Serzone = {};
Serzone.action = {};

(function (Serzone) {
    /*
     * Utility
     */
    function arrayify (e) {
        return Array.prototype.slice.call(e);
    }
    
    var translateMargin = {
        x : 30,
        y : 0,
    };
```


などとやってますが、この _abilify.js_ はコアの仕様を完全に把握している僕が作ったものですので、これを読み解くのは厄介です。

なので、とりあえず一からスタイルファイルを作ってみることにします。

## Serzoneの仕様


実際の作成に入る前に、知っておくべきことを列挙しておきます。

### ステップ


このスライドには木構造の各ノードに基いて、各アニメーションを実行します。その木構造のノードに基づくアニメーションを、 **ステップ** と呼称します。

例えば、あるスライドから次のスライドへの遷移も一つのステップですし、文字が出現するといった処理もステップです。

### `slide`クラス


まず、スライドを定義するタグには全て、`slide`というクラスが割り当てられます。なので、`slide`クラスを何か別の用途に使用している場合は、注意が必要です。

### `id`属性


スライドとステップには一意な`id`属性として、実行される順序がSerzone.jsのコアによって捩じ込まれます。

ここで注意するべきは、スライドも一つのステップなのですが、スライドには _slide-N_ （ _N_ は数字）といった形、スライド以外のステップは _step-N_ （ _N_ は数字）といった形の`id`属性が振られます。

これら二つを分けた理由はいろいろありますが、とりあえであると思ってください。

![class](http://dl.dropbox.com/u/16667824/Serzone/class_id.png)

### id="serzone"


プレゼンテーションのデータ部分は、`<div id="serzone">`に囲われた範囲にあります。この部分はコアによるパースが終っても削除されません。

多くの場合は消し去るか、表示しないようにしたいと思いますが、そこは自力でやる必要があるます。

### id="canvas"


Serzone.jsのコアは、パース終了時に`<div id="canvas">`というタグを`<body>`の直後配置します。

このHTMLElementは、`Serzone.canvas`という名前でアクセス出来ます。通常、スタイルファイルはこの領域のみに変更を加えるべきです。

## スタイルファイル作成の準備


ここでは、 _hoge.js_ というスタイルを作成してみましょう。

### ファイル作成


とりあえず、生成するファイル _hoge.js_ を、`js`フォルダの中に作りましょう。

```
$ touch js/hoge.js
```


### 使用する名前空間


各ステップに対応する形でアニメーションを始め定義するのですが、これは、`Serzone.action`という名前空間を用います。

例えば、 _hoge_ というステップを新たに登録する場合、`Serzone.action.hoge`という名前空間に処理を記述することになります。無事に _hoge_ を定義出来れば、プレゼンテーションファイル内で`<hoge>`というタグを用いアニメーションなどの処理を招喚出来ます。

今回は、とりあえずスライドの遷移を作ってみます。

### おまじない


C言語などにもおまじないがあるように、このプログラムにもおまじないがあります。

「はじめに」で抜粋したHTMLファイルを見ると分かるかもしれませんが、このスタイルファイルは実装の関係上、コアファイル（ _Serzone.js_ ）よりも先に呼び出されます。従って、`Serzone`の名前空間と、ステップの処理を記述する`Serzone.action`の名前空間を初期化する必要があります。ゆえに、スタイルファイルの先頭は次の二行から始まります。

```javascript
var Serzone    = {};
Serzone.action = {};
```


### アクション


ここでは、ステップによって呼び出されるアニメーション、つまりはスタイルファイルで定義された命令を、 **アクション** と呼ぶことにします。

さて、ではがんばってアクションを定義してゆくわけですが、まずこれらがどのようなフォーマットなのかを説明します。

具体的には次のようなプロパテイを持つオブジェクトです。

* type
* next
    - init (Function)
    - fire (Function)
* back
    - init (Function)
    - fire (Function)


例えば、 _abilify.js_ の中で、`appear`ステップのアクションは次のように定義されています。

```javascript
appear : {
    type : "inherit",
    next : {
        init : function (body) {
            console.log("appear next init");
            $(body).hide();
        },
        fire : function (body) {
            console.log("appear next fire");
            $(body).show(1000);
        }
    },
    back : {
        init : function () {
            // none
            console.log("appear fire init");
        },
        fire : function (body) {
            $(body).hide(1000);
            console.log("appear fire fire");
        }
    }
},
```


各プロパティについて説明してゆきます。ただ命令の関係で、順序通りに説明するよりも適当な順で説明します。

#### next, back


これらは同じ構造（ _init_ と _fire_ というメソッドを持つ）を取ります。これらはそれぞれ「進む処理」と「戻る処理」に対応しています。

#### init, fire


これらは、 _next_ と _back_ の下にあるメソッドです。 _init_ には前駆処理、 _fire_ には実際の処理を記述するのが普通です。

例えば、 _abilify.js_ の`next.appear`では、(console.logは省略した。)

```javascript
next : {
    init : function (body) {
        $(body).hide();
    },
    fire : function (body) {
        $(body).show(1000);
    }
},
```


となっています。これは、

<dl>  <dt>前駆処理（init）</dt>  <dd>文字列を消す</dt>  <dt>メイン処理（fire）</dt>  <dd>文字を出す</dd></dl>

となっていて、なんとなく直感的なのではないかと思います。

#### type


これは次の三つしか選択肢がありません。

* changeSlide
* inherit
* else


_changeSlide_ は、このアクション（この名前のタグ）がスライドの遷移であることを主張します。この _type_ を持つアクションを二つ以上定義すると、多分破滅が起きますのでやめた方がいいでしょう。 _abilify.js_ では`<section>`に割り当てています。

_inherit_ は木構造における親のステップ（ノード）が発火した時、下（自身）までその処理を伝播させます。ただ、上のステップの _init_ 、 _fire_ いずれが発火しても、自身が発火するのは _init_ だけです。 _inherit_ ではない _type_ が出現した時点で、伝播は中断されます。

_else_ は基本的に親のステップが発火しても自身のステップが発火しません。

先程から何度も出現している`appear`は、 _inherit_ が指定されているので、親のステップが発火するのと同時に前駆処理が発火することになります。

## スライドの移動を作る


では、簡単な物体を作ってみましょう。

### おまじないと基礎の付与


まずは、空の _hoge.js_ に、おまじないなどを付与します。

```javascript
var Serzone = {};
Serzone.action = {};

Serzone.action = {
    section : {
        type : "changeSlide",
        next : {
            init : function (slide) { }
            fire : function (slide) { }
        },
        back : {
            init : function (slide) { }
            fire : function (slide) { }
        }
    }
};
```


ここに、 _back_ と _next_ を考えればよいということです。

### スライド遷移の仕様を決める


どのようなアニメーションにするのかですが、とりあえず最も簡単な、PowerPoint風の、次の板に進むようなデザインでゆこうかと思います。

すると、進む時にやることは、

1. `Serzone.canvas`にある、一つ前のスライドを取り除く
2. `Serzone.canvas`に、現在のスライドを入れる。


という感じです。

また戻る時は、

1. `Serzone.canvas`から、現在のスライドを抜く。
2. `Serzone.canvas`に、一つ前のスライドを入れる。


なので、それぞれの _init_ に2を、 _fire_ に1を入れます。

### init, fireの引数


これらは _changeSlide_ とそれ以外で引数が変わります。

#### changeSlide


1. `slide`オブジェクト
2. _1_ を`$obj`に内包する`step`オブジェクト


これらの詳細はWikiの[Slideオブジェクト](https://github.com/yoshimuraYuu/Serzone/wiki/slideObject)と、[Treeオブジェクト](https://github.com/yoshimuraYuu/Serzone/wiki/treeObject)、さらには、[Stepオブジェクト](https://github.com/yoshimuraYuu/Serzone/wiki/stepObject)のページを見てください。

#### changeSlide以外


1. そのタグで囲われたHTMLElement
2. _1_ を`$obj`に内包する`step`オブジェクト


上記のWikiをお願いします。

### 作る


[jQuery](http://jquery.com/)使えば簡単ですね。

```javascript
var Serzone = {};
Serzone.action = {};

Serzone.action = {
    section : {
        type : "changeSlide",
        next : {
            init : function (slide) {
                if (slide.order == 0) {
                    $("#serzone").remove();
                }

                $(Serzone.canvas).append(slide.body);
            },
            fire : function (slide) {
                $(slide.body).remove();
            }
        },
        back : {
            init : function (slide) {
                $(slide.body).remove();
            },
            fire : function (slide) {
                $(Serzone.canvas).append(slide.previous.body);
            }
        }
    }
};
```


### デモ


このファイルは[こんな感じ](http://yoshimurayuu.github.com/Serzone/hoge.html)になります。

## その他


### alwaysアクション


_abilify.js_ にある _always_ アクションは特殊で、この名前持つアクションは、あらゆるアクションの前に実行されます。

![always](http://dl.dropbox.com/u/16667824/Serzone/always.png)

