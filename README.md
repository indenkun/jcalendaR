
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jcalendaR

<!-- badges: start -->
<!-- badges: end -->

**English version of README is not available for now.**

`jcalendaR`はRで和暦と旧暦、西暦（ユリウス暦、（先発）グレゴリウス暦）の年月日を相互変換を行うためのパッケージです。

## 機能

- 和暦から西暦（ユリウス暦、（先発）グレゴリウス暦）への変換ができます。

- 旧暦から西暦（ユリウス暦、（先発）グレゴリウス暦）への変換ができます。

- 西暦（ユリウス暦、（先発）グレゴリウス暦）から和暦への変換ができます。

- 西暦（ユリウス暦、（先発）グレゴリウス暦）から旧暦への変換ができます。

- 年号を付与しない場合は旧暦は1年1月1日（先発グレゴリオ暦1年2月10日）から2100年12月1日（グレゴリウス暦2100年12月31日）までしか対応していません。

  - それ以前または以後の年月日を入力すると警告文とともにNAを出力するか、計算できないか、変な値を返します。

- 年号は、景行天皇以降（旧暦17年以降）の元号に対応してています。

  - 旧字体（例えば慶應など）には対応していません。
  - 元号について、現在のところ西暦から和暦・旧暦への変換時に付与する元号は改元した日以降で付与され、改元の年始は前の元号で出力されます。つまり、明治以前でみられる改元したとしの年始にさかのぼって改元が適応される形式には西暦からの変換の場合は対応していません。
  - 和暦・旧暦から西暦への変換の場合は改元された年の年始からその元年として扱えます。
  - 和暦・旧暦から西暦への変換の場合はその年号が改元されずに続いた場合の年数でも計算できます。
  - 現在以降の年月日については現在の元号が続いていくものとみなして出力します。
  - 過去の元号について、南朝だけでなく指定することで北朝、平家、京都、関東地方で使用されていた元号で対照することもできます。

- 旧暦の閏月は「閏」と「うるう」の両方の表記をサポートします。

- 改元の最初の年は「元年」と「1年」の両方の表記をサポートします。

- 和暦と旧暦は明治5年以前は一致します。

- 旧暦の暦法および、元号の表記および改元日は参照元データによるものです。

- 内部的に、ユリウス通日を計算しています。

- 西暦から（修正）ユリウス通日、（修正）ユリウス通日から西暦へ変換する関数もあります。

## Installation

リリース版はCRANからインストールできます。

``` r
install.package("jcalendaR")
```

開発版はGithubからインストールできます。

``` r
remotes::install_github("indenkun/jcalendaR")
```

## Example

``` r
library(jcalendaR)
```

### 和暦と西暦

``` r
wareki2seireki("令和3年1月1日")
#> [1] "2021/1/1"
```

``` r
seireki2wareki("2021/1/1")
#> [1] "令和3年1月1日"
```

``` r
wareki2seireki("天正6年3月13日", calendar = "julian")
#> [1] "1578/4/19"
```

``` r
seireki2wareki("1578/4/18")
#> [1] "天正6年3月2日"
```

### 旧暦と西暦

``` r
kyureki2seireki("令和3年1月1日")
#> [1] "2021/2/12"
```

``` r
seireki2kyureki("2021/1/1")
#> [1] "令和2年11月18日"
```

### 和暦と旧暦

``` r
wareki2kyureki("令和3年1月1日")
#> [1] "令和2年11月18日"
```

``` r
kyureki2wareki("令和2年11月18日")
#> [1] "令和3年1月1日"
```

### utils

旧暦の指定した年に閏月があるかどうか、理論型か閏月の値で答えます。

指定する年の値は年号と数字で構成される必要があります。数字の後ろに年がついているかどうかは問いません。

``` r
existence_leap.month("明治2")
#> [1] FALSE
```

``` r
existence_leap.month("明治2", existence = "number")
#> [1] NA
```

``` r
existence_leap.month("明治3年", existence = "logical")
#> [1] TRUE
```

``` r
existence_leap.month("明治3年", existence = "number")
#> [1] 10
```

旧暦の指定した年の指定した月が何日あるか。閏月を指定した場合、その年に閏月がないならその旨を警告文で出します。

指定する年の値は年号と数字で構成される必要があります。数字の後ろに年がついているかどうかは問いません。

また、指定する月は数値または文字列で、文字列の場合に数字の後ろに月がついているかどうかは問いません。

``` r
number_kyureki.month("明治2", 1)
#> [1] 30
```

``` r
number_kyureki.month("明治2年", "閏1")
#> Warning: There are no leap months in that year.
#> [1] NA
```

``` r
number_kyureki.month("明治3", "閏10月")
#> [1] 29
```

### ユリウス通日と西暦

``` r
jdn2calendar(2459216)
#> [1] "2021/1/1"
```

``` r
calendar2jdn("2021/1/1")
#> [1] 2459216
```

### 警告文が出力されるパターン

``` r
seireki2wareki("1/1/1")
#> Warning: Entered a date older than the supported period.
#> [1] NA
```

``` r
wareki2seireki("天保2年2月30日")
#> Warning: The number of days entered does not exist for the month.
#> [1] NA
```

``` r
wareki2seireki("0年1月1日", era = "non")
#> Warning: Entered a date older than the supported period.
#> [1] NA
```

``` r
kyureki2seireki("2101年1月1日", era = "non") 
#> Warning: Entered a date that is farther in the future than the supported dates.
#> [1] NA
```

# 参照

ユリウス通日の計算には[ユリウス通日 -
Wikipedia](https://ja.wikipedia.org/wiki/ユリウス通日)の式を用いています。

# 参照元データ

グレゴリウス暦と旧暦の対照表、元号について以下のデータを参照しました。

- [manakai/data-locale](https://github.com/manakai/data-locale)

# Known Issues and Future Tasks

- 関数製作者は暦についての専門家ではありません。なにか不備があればお知らせください。
- 参照元データの典拠である日本暦日原典の対照表が、どの暦法を元にしているのか分かっていません。単にデータだけを利用しています。詳細はデータの参照元のドキュメントの<https://github.com/manakai/data-locale/blob/master/doc/calendar-kyuureki.txt>を参照してください。
- 不適切な値が入力された場合に警告文を表示しNAを出力する場合と処理が完了しない警告があり、統一されていません。
- 琉球暦未対応。

# License

MIT
