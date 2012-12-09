# LuaTeXによるマンデルブロ集合の描画

この記事は[TeX & LaTeX Advent Calendar](http://atnd.org/events/34318)における、九日目の記事です。
前日の記事は[Ubuntu 12.04/Debian Squeeze での TeXLive (>=2012) 環境](http://uwabami.junkhub.org/log/20121208p01.html)です。

## 経緯

学校の課題でマンデルブロ集合の絵を、好きなプログラム言語で作って提出せよと言われた。
友人がPostScriptを使っていたので、「おもしろ言語部門」第二位を狙って、
LuaTeXで作ることにしてみた。

## マンデルブロ集合

授業をマジメに聞いていなかったので、
そもそもマンデルブロ集合がなんなのか全く分からなかったので、
Wikipediaで適当に調べてみた。

![マンデルブロ集合の図](http://dl.dropbox.com/u/16667824/mand.png)

こんな感じの図。

### 計算式

マンデルブロ集合は次の計算によって表せるらしい。

![計算式（Wikipediaより）](http://upload.wikimedia.org/math/7/4/7/74718d43259e856561fd0cefea425de3.png)

まあ、これをやればなんとかなるんじゃないかなと。

### 浮動小数計算

そこまで考えたところで、LaTeXのレジスタ計算は整数のみと気付く。
FPパッケージなどを使うことも考えたものの、
適当にぐぐるとLuaTeXの存在を知る。

## LuaTeX

Wikipediaによると、
TeXマクロなどの中に適宜Luaのコードを叩き込める処理系らしいと知る。
Luaはもちろん浮動小数演算が可能。
pdfTeXの後継として採用されているそうで、なんとなく期待出来そうなので
使ってみることにした。

### \directlua

こんな感じでLuaのコードを埋め込めるらしい。
とりあえず、浮動小数演算をやってみた。

```tex
\documentclass{standalone}
\def\plusPointFive#1{ \directlua{ tex.print(#1 + 0.5) } }

\begin{document}

\plusPointFive{15}

\end{document}
```

### コンパイル

LuaTeXはLaTeXに代わるマクロ群であるConTeXtを採用しているらしく、
従来のフォーマット（`\documentclass`から始まるもの）が使えないみたい。
ただ、互換モードが用意されているらしく、`lualatex hoge.tex`とやればいい模様。

### 結果

![15.5](http://dl.dropbox.com/u/16667824/15.5.png)

やったぽよ。

## マンデルブロ集合の実装

綺麗な絵を出したかったので、
[TikZ](http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?TikZ)君に描画を依頼した。
まあ、エクセル方眼紙みたいなものを作って、計算によって塗り潰す色を選択するだけなので、
こんなの簡単簡単。


### 最初

```tex
\documentclass{standalone}
\usepackage{tikz}
\usepackage{luacode}

\def\escapetime#1#2{\directlua{tex.print(escape_count(#1,#2))}}
\def\mandcolor#1#2{\directlua{mand_color(#1,#2)}}
```

必要なものを呼び出すのと、Luaの関数とLaTeXを結ぶマクロを定義。

### luacode環境

`\directlua`の中に大量のLuaコードを書くのは現実的ではないので、
`luacode`環境を使って、その中に大量のコードを書く。

```tex
\begin{luacode}

... Many Lua Code ...

\end{luacode}
```

以降のLuaコードは全部この`luacode`環境の中に詰めている。

### x, y座標の生成

漸化式に基いて、x, y座標を生成する関数を生成する関数を定義する。

```lua
make_fun_calc_point = function (a, b) 
	local i = 1
	local x = a
	local y = b

	return function ()
		x, y = x * x - y * y + a, 2 * x * y + b
		i = i + 1
		return i, x * x + y * y
	end
end
```

高階関数を使えるあたり、人道的ですな。

### 発散の判定

発散を判定する関数。

```lua
local LIMIT = 100

escape_count = function (a, b)
	local count

	for i, d in make_fun_calc_point(a, b) do
		count = i
		if (d > 4 or count > LIMIT) then
			break
		end
	end

	return count
end
```

詳しくはWikipediaなどを見てください。
（僕もよく分かってない）

### 描画する色の決定

今回は集合を青、境界を赤、発散の速度に応じて濃さを変えることにした。

```lua
mand_color = function (a, b)
	local count = escape_count(a, b)

	if (count > LIMIT) then
		tex.print("blue")
	else
		tex.print("red!"..count)
	end
end
```

### 描画

ループで升目を総当たりして、集合に入っているのか判定する。
精度は小数点第三位（千分の一）まで。

```tex
\begin{document}

\begin{tikzpicture}[scale=6]
\foreach \x in {-1.8,-1.799,...,.6}{
	\foreach \y in {-1.00,-0.999,...,1}{
		\draw[\mandcolor{\x}{\y},fill] (\x,\y) +(-.0005,-.0005) rectangle +(.0005,.0005);
	}
	\typeout{\x}
}
\end{tikzpicture}

\end{document}
```

## 結果

手始めに2400 x 2000の画像を作ったところ、次のようになった。

```
238124216 words of node memory still in use:
   7 hlist, 1 vlist, 1 rule, 11001070 glue, 43 glue_spec, 1 write, 52080872 pdf
_literal, 9469252 pdf_colorstack nodes
	avail lists:1:11, 2:29, 3:52080874, 4:20470344, 5:1, 6:8, 7:1, 9:13
Output written on mand.pdf (1 page, 104999331 bytes).
Transcript written on mand.log.
lualatex mand.tex  9016.01s user 84.57s system 93% cpu 2:42:13.31 total
```

時間としては約150分かかり、約105MBの[巨大なPDF](http://db.tt/vKCfqV02)が吐き出された。

## mandelbrot-flood-fill

あまりにも遅過ぎるので、アルゴリズムを最適化した。
[このサイト](http://www.bsddiary.net/d/20110708.html)にある手法で、
具体的には次のような仕組みで描画する部分を選択する。

1. 矩形内の一番外側の各点をキューに入れる。
2. キューが空なら終了。
3. キューから 1 点取り出す。
4. その点が「計算済み」なら 2 へ。
5. その点について繰り返し計算を行い「計算済み」とする。
6. その点がマンデルブロ集合に含まれるなら 2 へ。
7. 周囲の 8 近傍点をキューに入れて 2 へ。 

どうしてこれで速くなるのかは、上記のサイトに書いてあるので省く。

ともかく、とんでもない悪魔テクを使わなければ配列すら使えないTeXと違って、
Lua君の力なら配列など造作もなく、従ってキューも造作もない。
こんなの簡単簡単。

ただ、Lua君には配列というプリミティブな型はなく、
Tableという連想配列のようなプリミティブしかない。
まあそれでも、TeXに比べれば大分マシ。

ここでは便宜的に、キーの名前が0, 1, 2, ..., n, ...というようなテーブル（連想配列）を、
配列と呼ぶことにする。

### 短形の一番外側を取得

```lua
mand_color_init = function (x_start, x_end, y_start, y_end, d)
	local que = {}

	for x = x_start, x_end, d do
		table.insert(que, {x, y_start})
	end

	for y = y_start, y_end, d do
		table.insert(que, {x_end, y})
	end

	for x = x_start, x_end, d do
		table.insert(que, {x, y_end})
	end

	for y = y_start, y_end, d do
		table.insert(que, {x_start, y})
	end

	return que
end
```

始点と終点のx, y座標と、細かさ`d`で生成出来る。
出来たものを返す。

### 近傍点の取得

こういう時にOCamlなどにある、タプル型のありがたみをしみじみ思う。

```lua
make_get_neighbor_points = function (x_start, x_end, y_start, y_end, d)
	return function (p, drew)
		local candidate = {
			{p[1]-d, p[2]+d}, {p[1],   p[2]+d}, {p[1]+d, p[2]+d},
			{p[1]-d, p[2]},						{p[1]+d, p[2]},
			{p[1]-d, p[2]-d}, {p[1],   p[2]-d}, {p[1]+d, p[2]-d} }
		local final = {}

		for i, e in pairs(candidate) do
			if (e[1] > x_start and e[1] < x_end and e[2] > y_start and e[2] < y_end and not (drew[table.concat(e, ",")])) then
				table.insert(final, e)
			end
		end

		return final
	end
end
```

基本的には近傍の八点をキューに追加するようにしているが、
描画する短形からはみ出た点、既に描画した点についてはキューに追加しない。

### 描画色の決定 

```lua
mand_color = function (x_start, x_end, y_start, y_end, d, conf)
	local que                 = mand_color_init(x_start*conf, x_end*conf, y_start*conf, y_end*conf, d*conf)
	local get_neighbor_points = make_get_neighbor_points(x_start*conf, x_end*conf, y_start*conf, y_end*conf, d*conf)
	local drew   = {}
	local half_d = d / 2

	e = table.remove(que, 1)
	while (e) do
		if ( not (drew[table.concat(e, ",")]) ) then
			drew[table.concat(e, ",")] = true
			local count = escape_count(e[1]/conf, e[2]/conf)

			if (count < LIMIT) then
				tex.print("\\draw[red!"..count..", fill] ("..e[1]/conf..", "..e[2]/conf..") +(-"..half_d..",-"..half_d..") rectangle +("..half_d..","..half_d..");")

				for i, n in pairs( get_neighbor_points(e, drew) ) do
					table.insert(que, n)
				end
			end
		end
		e = table.remove(que, 1)
	end
end
```

描画と発散の計算以外では定数（`conf`）をかけて整数となるようにしている。
細かい数をLuaの中で計算するので、
誤差による描画済みの判定ミスを無くす必要があった。
この判定にしくじると無限ループに陥いる可能性がある。

### 描画

描画部分は前のまま。

### 結果

最適化したコードを用いて、
前回と同様の解像度、2400 x 2000のマンデルブロ集合を描画させた。

```
 146583118 words of node memory still in use:
   7 hlist, 1 vlist, 1 rule, 3257414 glue, 43 glue_spec, 1 write, 35831330 pdf_
literal, 6514790 pdf_colorstack nodes 
	avail lists: 1:16,2:30,3:35831332,4 : 9772226,5:1,6:8,7:1,9:13
Output written on mand-fast.pdf (1 page, 78617901 bytes).
Transcript written on mand-fast.log.
lualatex mand-fast.tex  15381.89s user 36.68s system 99% cpu 4:19:03.31 total

```

約四時間かかっており、前回よりも二倍ほど増加した。
解像度の低い画像（240 x 200）であると、こちらのアルゴリズムで計算する方が、
二倍程度早くなったので、どうしてこちらの方が遅くなったのかは謎。

ファイルサイズは78.6MBと、前回の方式で作った画像よりも二割ほど小さくなった。
これは、集合に含まれる部分を短形で全て塗り潰すので、
前回やったように一点一点を塗るものより情報量が少なくて済むのであろう。

作成したPDFファイルは[ここ](http://db.tt/7rDNwzMZ)に設置した。

## 結論

なんとかおもしろ言語部門に入れそうな感じになったが、
単位が来るかどうかはまだ謎。

そういえば、PostScriptの方が圧倒的に速かった。
