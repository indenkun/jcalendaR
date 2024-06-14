#' wareki2kyureki
#' @description
#' A set of functions for mutual conversion between Kyureki that the old Japanese calendar and Wareki that the current Japanese calendar. For years before 1872, Kyureki and Wareki are identical. After 1873, the Gregorian calendar was adopted in Japan, and there is a difference from there.
#'
#' @param date Date to be converted. It should always include the year, month, and day.
#' @param era Whether the Gengo of the Japanese calendar is the Southern or Northern dynasty system, the system used in the Kanto region, the Heike, and Kyoto respectively, or no era names.
#' @param one Whether to write the year in kanji as the first year or leave it as a number.
#' @param leap.month Whether to write leap months in Kanji or Hiragana.
#' @param sep The way the date is separated when the last date is written.
#'
#' @return String type date.
#'
#' @references
#' The data for the Kyureki calendar and era names refer to the following data.
#'
#' manakai/data-locale \url{https://github.com/manakai/data-locale}
#'
#' @examples
#' wareki2kyureki("\u4ee4\u548c3\u5e741\u67081\u65e5")
#' kyureki2wareki("\u4ee4\u548c2\u5e7411\u670818\u65e5")
#'
#' @rdname wareki2kyureki
#' @export

wareki2kyureki <- function(date,
                           era = c("south", "north", "east", "heishi", "kyoto", "non"),
                           one = c("kanji", "number"),
                           leap.month = c("kanji", "hiragana"),
                           sep = c("kanji", "/", "-")){
  era <- match.arg(era)
  one <- match.arg(one)
  leap.month <- match.arg(leap.month)
  sep <- match.arg(sep)

  date <- wareki2seireki(date = date, calendar = "gregorian", era = era, sep = "/")
  date <- seireki2kyureki(date = date, calendar = "gregorian", era = era, one = one, leap.month = leap.month, sep = sep)
  ans <- date

  ans
}

#' @export
#' @rdname wareki2kyureki

kyureki2wareki <- function(date,
                           era = c("south", "north", "east", "heishi", "kyoto", "non"),
                           one = c("kanji", "number"),
                           leap.month = c("kanji", "hiragana"),
                           sep = c("kanji", "/", "-")){
  era <- match.arg(era)
  one <- match.arg(one)
  leap.month <- match.arg(leap.month)
  sep <- match.arg(sep)

  date <- kyureki2seireki(date = date, calendar = "gregorian", era = era, sep = "/")
  date <- seireki2wareki(date = date, calendar = "gregorian", era = era, one = one, leap.month = leap.month, sep = sep)
  ans <- date

  ans
}
