# JavaScrpit イベントドリブン処理の制御


# 概要 


JavaScriptでは _addEventListener_ を使ってイベントを登録出来るが、現在イベントをしている時は、同じイベントを発生させないで欲しい時がある。そういう時のやり方が、Webにはあまり書いてなかったのでやってみた。

# やり方


このようにやる。

```javascript
var time = 1000;

document.addEventListener("keydown", function f (e) {
    //　何かの処理

    document.removeEventListener("keydown", f, true);

    setTimeout( function () {
        document.addEventListener("keydown", f, true);
    }, time);
}, true)
```


という感じにすると出来る。

# 何に使ったのか


CSSのアニメーションを処理する間、イベントドリブンで発火する処理を止めておきたかったのでやってみた。

# まとめ


もっといい方法があれば教えてください。