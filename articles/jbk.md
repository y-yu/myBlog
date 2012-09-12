# jbk10.cloを読む


必要に駆られたのでまとめる。基本は`jbk10.clo`に登場するものとする。

`jbk10.clo`は`jbook.cls`でフォントとテキストを司る部分である。クラス独自のものについては、`jclasses.dtx`を参考にする。

## ユーティリティ系


本質的ではないもの。

### \p@


1ptを表わす寸法レジスタ。同じ類いのものに`\z@`というものがあり、こちらは0ptを表す。

### \@plus (plus)


グルーの伸びしろを設定する予約語`plus`の制御綴版。どういうことかというと、

```tex
\kanjiskip = 10pt plus 15pt
```


というふうに使うと、`\kanjiskip`は10ptから **25（10 + 15）pt** の中でグルーを調整（均等割）する。

### \@minus (minus)


`plus`と同じようなもの、下限を決定する。ただし、`10pt minus 5pt`とすると、**5（10 - 5）pt** の間で調整するようになる。

### @compatibility


互換モードかどうかの判定を行っている。LaTeXかLaTeX2eかなので、基本的にはLaTeX2e（互換モードではない）と考えてもいいだろう。つまり`\if`にこれが指定された場合、`\else`しか関係ないと考えてよい。

### @stysize


pLaTeX2e 2.09互換モードの時に使われるフラグ。用紙サイズのエミュレートに使われる。互換モードの際に _false_ となる。

### @twocolumn


二段組にするかどうかのオプション。

```tex
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
```


### \@settopoint


`latex.ltx`による定義はこうなっている。

```tex
\def\@settopoint#1{\divide#1\p@\multiply#1\p@}
```


よく分からんが、実験してみると小数点以下が犠牲になる。

```tex
\newlength\hoge
\setlength\hoge{10cm}

\the\hoge
% 284.52756pt

\makeatletter
\@settopoint\hoge
\makeatother

\the\hoge
% 284.0pt
```


## 寸法


レイアウトの長さに関するもの。

### \abovedisplayskip \abovedisplayshortskip \belowdisplayskip \belowdisplayshortskip


数式のスペースを設定する。`jbk10.clo`では

* `\abovedisplayskip`
* `\abovedisplayshortskip`
* `\belowdisplayshortskip`
* `\belowdisplayskip`


を`\nomalsize`や`\small`で一気に設定しているらしい。

### \baselineskip


行間の長さ。

### \@listi \@listI


リスト環境に使われている模様。詳細は不明。

### \Cht \Cdp \Cwd \Cvs \Chs


たぶん、一文字（一行）の基準となる長さ。`jbk10.cls`では、

```tex
\setbox0\hbox{\char\euc"A1A1}%
\setlength\Cht{\ht0}
\setlength\Cdp{\dp0}
\setlength\Cwd{\wd0}
\setlength\Cvs{\baselineskip}
\setlength\Chs{\wd0}
```


となっている。

* `\Cht` : 文字の高さ
* `\Cdp` : 文字の深さ（基準線を下に貫く長さ）
* `\Cwd` : 文字の幅
* `\Cvs` : 行送り（行間）
* `\Chs` : 字送り


の基準と考えられる。

### \headheight \headsep \topskip \footskip


さまざまな距離。

```tex
\setlength\headheight{12\p@}
\setlength\headsep{.25in}
\setlength\topskip{1\Cht}
\setlength\footskip{.35in}
```


* `\headheight` : ヘッダ入るボックス高さ。
* `\headsep`    : ヘッダと本文領域の距離。
* `\topskip`    : 本文領域の上端と一行目のテキストのベースラインの距離。
* `\footskip`   : 本文領域の下端とフッタの下端との距離。


### \maxdepth


`\topskip`と同じような働きをするらしい。

```tex
\if@compatibility
  \setlength\maxdepth{4\p@}
\else
  \setlength\maxdepth{.5\topskip}
\fi
```


LaTeX2eでは`\maxdepth` + `\topskip`が基本の高さ（1`\Cht`）の1.5倍にしたいらしいので、このようにしてある。

### \paperwidth \paperheight


紙の大きさ。

```tex
\DeclareOption{b5j}{\setcounter{@paper}{4}\@stysizetrue
  \setlength\paperheight {257mm}
  \setlength\paperwidth  {182mm}}
```


JIS B5だとこうなるみたい。

### \textwidth \textheight


本文が描画される部分の横幅と縦幅。

```tex
\if@twocolumn
  \setlength\textwidth{.8\paperwidth}
\else
  \setlength\textwidth{.7\paperwidth}
\fi
```


```tex
\setlength\textheight{.70\paperheight}

addtolength\textheight{\topskip}
```


`jbk10.clo`は互換モードではない場合、`\textwidth`は二段組の時紙の八割で、二段組ではないときに紙の七割となるらしい。

### \topmargin


印刷可能領域（用紙の端から一インチ内側）の上端から、ヘッダ部分の上端までの距離。

`jbk10.clo`によると、

```tex
\setlength\topmargin{\paperheight}
\addtolength\topmargin{-\headheight}
\addtolength\topmargin{-\headsep}
\addtolength\topmargin{-\textheight}
\addtolength\topmargin{-\footskip}
\if@stysize
  \ifnum\c@@paper=2 % A5
    \addtolength\topmargin{-1.3in}
  \else
    \addtolength\topmargin{-2.0in}
  \fi
\else
  \addtolength\topmargin{-2.0in}
\fi
\addtolength\topmargin{-.5\topmargin}
\@settopoint\topmargin
```


となっている。

### \marginparpush \marginparsep \marginparwidth


傍注に関するマージン。

* `\marginparpush` : 傍注間の幅の指定
* `\marginparsep` : 本文と傍注の間の幅の指定
* `\marginparwidth` : 傍注の幅の指定


### \oddsidemargin \evensidemargin


印刷可能領域からの左右マージン。

### \footnotesep


各脚注の上に入る支柱（空箱）の高さ。脚注と脚注の間にあるマージンみたいに思える。

### \skip\footins


本文の最後と最初の脚注までの距離。

### \floatsep \textfloatsep \intextsep \dblfloatsep \dbltextfloatsepなど


フロートオブジェクトに関する設定らしい。フロートに関することは後で考える。

## コマンド


何かやるコマンド的なもの。

### \@setfontsize


フォントの大きさを指定する。

```tex
\@setfontsize\normalsize\ixpt{15}
```


**引数**

1. 設定したい制御綴。
2. 文字サイズ（数値の場合はポイントとして扱う）
3. `\baselineskip`の基準値


詳しいことはhttp://www.h4.dion.ne.jp/~latexcat/column/column1.html に書いてある。

## まとめ


あとで`jbook.cls`もやる。