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

## ユーティリティ


### \@tempdima \@tempdimb \@tempdimc


一時的に寸法を格納するレジスタ。

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

