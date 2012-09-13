# jbook.clsを読む


前回の続き。フォントとそれに伴う用紙の設定は`jbk10.clo`で大体把握したので、次は`jbook.cls`を読むことにした。

**量が多いので、使わなさそうな奴は省く。**

## フラグ


### @landscape @landscapetrue @landscapefalse


紙を横に使うか縦に使うかのフラグ。横向きの時に _true_ になる。

### @titlepage @titlepagetrue @titlepagefalse


タイトルページとアブストラクトを別のページにするかどうか。

### @openright


`\chapter`を右のページから始めるかどうか。

### @mainmatter \@mainmattertrue


`\chapter`の見出し番号を出すかどうか。

### \twosidetrue \twosidefalse


偶数ページと奇数ページの体裁を変えるかを指定する。

### \twocolumntrue \twocolumnfalse


二段組にするかどうか。

## 寸法


### \@ptsize


文字の大きさ（ポイント）を表わす。

`jbook.cls`では、

```tex
\input{jbk1\@ptsize.clo}
```


として、ポイントにあった _clo_ ファイルを読み込んでいる。

### \columnsep \columnseprule


`\columnseq`は二段組時の、左右のテキストの幅。`\columnseprule`はその時に、中央に引かれる線の太さ。

### \baselinestretch


`\baselineskip`の倍率を指定する。変更は`\renewcommand`でやる。

### \parskip \parindent


`\parskip`は段落間の幅。`\parindent`は段落一文字目のインデント。

## レイアウト


### \@evenhead \@oddhead \@evenfoot \@oddfoot


* `\@evenhead` : 奇数ページのヘッダ
* `\@oddhead` : 偶数ページのヘッダ
* `\@evenfoot` : 奇数ページのフッタ
* `\@oddfoot` : 偶数のページのフッタ


### \ps@plain


フッタにページ番号を出力する。

```tex
\def\ps@plain{\let\@mkboth\@gobbletwo
   \let\ps@jpl@in\ps@plain
   \let\@oddhead\@empty
   \def\@oddfoot{\reset@font\hfil\thepage\hfil}%
   \let\@evenhead\@empty
   \let\@evenfoot\@oddfoot}
```


### \ps@jpl@in


`\tableofcontents`や`\theindex`で使われるページレイアウト。

### \ps@headnombre


ヘッダにページ番号を出力する。

```tex
\def\ps@headnombre{\let\@mkboth\@gobbletwo
    \let\ps@jpl@in\ps@headnombre
  \def\@evenhead{\thepage\hfil}%
  \def\@oddhead{\hfil\thepage}%
```


### \ps@footnombre


フッタにページ番号を出力する。

```tex
\def\ps@footnombre{\let\@mkboth\@gobbletwo
    \let\ps@jpl@in\ps@footnombre
  \def\@evenfoot{\thepage\hfil}%
  \def\@oddfoot{\hfil\thepage}%
  \let\@oddhead\@empty\let\@evenhead\@empty}
```


若干`\ps@plain`と違う。

### \ps@headings


ヘッダに`\thechapter`とページ番号に入れる。

```tex
% not two side
\def\ps@headings{\let\ps@jpl@in\ps@headnombre
  \let\@oddfoot\@empty
  \def\@oddhead{{\rightmark}\hfil\thepage}%
  \let\@mkboth\markboth
\def\chaptermark##1{\markright{%
  \ifnum \c@secnumdepth >\m@ne
        \if@mainmatter
      \@chapapp\thechapter\@chappos\hskip1zw
        \fi
  \fi
  ##1}}%
}
```


### \ps@bothstyle


ヘッダに見出し、フッタにページ番号を出力する。

```tex
\def\ps@bothstyle{\let\ps@jpl@in\ps@footnombre
  \def\@oddhead{\hfil\rightmark}%
  \def\@oddfoot{\hfil\thepage}%
  \let\@mkboth\markboth
\def\chaptermark##1{\markright{%
   \ifnum \c@secnumdepth >\m@ne
       \if@mainmatter
       \@chapapp\thechapter\@chappos\hskip1zw
       \fi
   \fi
   ##1}}%
}
```


### \ps@myheadings


ユーザがページスタイルを作る時の雛形。

## ユーティリティ


### \@tempdima \@tempdimb \@tempdimc


一時的に寸法を格納するレジスタ。

### @gobbletwo


何もしない。

### @empty


ヘッダやフッタに何も出力しない。

## コマンド


### \DeclareOption


オプションを宣言する。

```tex
\DeclareOption{b5j}{\setcounter{@paper}{4}\@stysizetrue
  \setlength\paperheight {257mm}
  \setlength\paperwidth  {182mm}}
```


**引数**

1. オプション名
2. 実行する命令


用紙サイズの指定に用いている。

### \thispagestyle


そのページスタイルを指定する。全てのページにスタイルを適用する場合は、`\pagestyle`を使う。

**引数**

1. ページスタイル


