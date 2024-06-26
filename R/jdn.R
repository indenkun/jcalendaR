#' jdn
#' @description
#' Functions for calculating Julian Date from Gregorian or Julian Date Number and functions for calculating Gregorian or Julian Date from Julian Date Number.
#'
#' @param date Date to be converted. It should always include the year, month, and day.
#' @param jdn Select Julius Date Number or Modified Julius Date Number.
#' @param calendar Select whether the calendar is Gregorian or Julian.
#'
#' @rdname jdn
#'
#' @returns
#' * `jdn2calendar` returns a string type date.
#'
#' * `calendar2jdn` returns a a numeric vector.
#'
#' @references
#' Julian Day Number - Wikipedia [ja] (JD, \url{https://ja.wikipedia.org/wiki/\%E3\%83\%A6\%E3\%83\%AA\%E3\%82\%A6\%E3\%82\%B9\%E9\%80\%9A\%E6\%97\%A5})
#'
#' Fliegel, H. F., Van Flandern, T. C. (1968), \doi{10.1145/364096.364097}, "A Machine Algorithm for Processing Calendar Dates", Communications of the ACM 11, p. 657.
#'
#' Hatcher, D. A. (1984, BibCode:1984QJRAS..25...53H) "Simple formulae for Julian day numbers and calendar dates, Quarterly Journal of the Royal Astronomical Society", v. 25, p. 53-55, \url{https://adsabs.harvard.edu/full/1984QJRAS..25...53H}.
#'
#' Meeus, J. (1998, ISBN:0943396638) "Astronomical Algorithms. Willmann-Bell", Second English Edition.
#'
#' @examples
#' jdn2calendar(2459216)
#' calendar2jdn("2021/1/1")
#'
#' @export

calendar2jdn <- function(date, jdn = c("jdn", "mjd"), calendar = c("gregorian", "julian")){
  calendar <- match.arg(calendar)
  jdn <- match.arg(jdn)

  unname(sapply(date, function(date){
    y <- as.numeric(format.Date(date, "%Y"))
    m <- as.numeric(format.Date(date, "%m"))
    d <- as.numeric(format.Date(date, "%d"))

    if(m <= 2){
      m <- m + 12
      y <- y - 1
    }

    if(calendar == "gregorian") ans <- floor(365.25 * y) + floor(y / 400) - floor(y / 100) + floor(30.59 * (m - 2)) + d - 678912
    else if(calendar == "julian") ans <- floor(365.25 * y) + floor(30.59 * (m - 2)) + d - 678914

    if(jdn == "jdn") ans <- ans + 2400001

    ans
  }))
}

#' @param n Julian Date Number or Modified Julian Date Number value.
#' @param sep The way the date is separated when the last date is written.
#'
#' @rdname jdn
#'
#' @export

jdn2calendar <- function(n, jdn = c("jdn", "mjd"), calendar = c("gregorian", "julian"), sep = "/"){
  calendar <- match.arg(calendar)
  jdn <- match.arg(jdn)

  unname(sapply(n, function(n){
    if(jdn == "jdn") n <- n - 2400001

    if(calendar == "gregorian"){
      n <- n + 678881
      a <- 4 * n + 3 + 4 * floor( (3 / 4) * floor((4 * (n + 1)) / 146097 + 1))
    }else if(calendar == "julian"){
      n <- n + 678883
      a <- 4 * n + 3
    }
    b <- 5 * floor((a %% 1461) / 4) + 2
    y <- floor(a / 1461)
    m <- floor(b / 153) + 3
    d <- floor((b %% 153) / 5) + 1

    if(m >= 13){
      m <- m - 12
      y <- y + 1
    }
    ans <- paste(y, m, d, sep = sep)
    ans
  }))
}
