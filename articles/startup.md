# GitHubでブログをやってみる


最近暇だということもあり、[JavaScriptの記事をGistで書いてみた](https://gist.github.com/3301790)ところ、割りといい感じになったので、これはいけるんじゃないかと思ってやってみた。

## GitHub Flavored Markdown


そもそもGitHubでブログとか抜かし始めたのは、この拡張マークダウン記法があったからだと思う。とりあえずソースコードを綺麗に貼れるだけでポイントが高いし、厄介な手続きを踏んで、アカウントを取得する手間もかからんので楽だろうと思った。試しにソースを載せると非常に美しく表示される。

```javascript
function arrayify (n) {
	return Array.prototype.slice.call(n);
}
```


## Gistの不満


最初はもうGistでいいか、みたいな感じだったけど、書いてるうちに段々イライラしてきた。

### エディタで書きたい


まずGistの枠で書いていたのだが、そのうちムカついてきたので、Firefoxのプラグインを使ってVimで編集することにした。しかし、このプラグインが色々バグって書いたものが消えたりしてさらにストレスが上がる。

そもそもVimで書いてるなら、始めからGitHubのリポジトリ使った方がいいと思い始める。

### 記事を一覧に出来ない


後で自分の記事を見直そうと思っても、どこに記事があるのか見つけ辛い。

### プレビュー出来ぬ


Saveするまでどうなってるのか分からんというのもどうなのか。

## GitHubでブログを快適に


そんな感じでGitHubでブログをやることにした。Markdownファイル作って _push_ すればいいので楽だと思っていたが、まあ、プレビューくらい出来ないと話しにならんので、なんとかしてみた。

### Markdown Rendering API


GitHubくんは心優しく、[WebAPI](http://developer.github.com/v3/markdown/)を提供していたようなので、`wget`でこのAPIを叩けばいい。シェルスクリプトを書く能力などなかったので、クソなPerlスクリプト書いて完。

```Perl
use 5.14.0;

my $result = `wget -O - --no-check-certificate --header="Content-Type: text/plain" --post-file="$ARGV[0]" https://api.github.com/markdown/raw`;

open my $fh, ">", $ARGV[1];

say $fh "<html>\n<head>";
say $fh '<link href="./css/reset.css" rel="stylesheet" type="text/css" />';
say $fh '<link href="./css/960.css" rel="stylesheet" type="text/css" />';
say $fh '<link href="./css/uv_active4d.css" rel="stylesheet" type="text/css" />';
say $fh '<link href="./css/documentation.css" media="screen" rel="stylesheet" type="text/css">';
say $fh '<link href="./css/pygments.css" media="screen" rel="stylesheet" type="text/css">';
say $fh '<link href="./css/documentation.css" media="screen" rel="stylesheet" type="text/css">';
say $fh "</head>\n<body>";

say $fh $result;

say $fh "</body>\n</html>";

close $fh;
```


この大量にインポートしているCSSは、あらかじめ引っ張っておいた。ちなみに[GitHub API v3](http://developer.github.com/v3/)によると、このAPIは一時間に五千発撃ってもいいらしいので、どっかの図書館みたいなことにはならなさそう。

### OMake


自動化する手法をこれしか知らないので、OMakefileを書く。

```
%.html: ./articles/%.md
	perl ./script/preview.pl $< $@
```


直下に生成されるHTMLファイルがプレビューになる。ブラウザで開いて、タブを自動更新にしておく。

## 記事を書く


1. `touch articles/newfile.md`
2. `omake -P newfile.html`
4. エディタで編集
5. `git add` & `git commit` & `git push`


という感じで記事が書けるだろう。

## まとめ


まあなんとかなるんじゃないかな。

