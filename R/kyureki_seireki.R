#' kyureki
#'
#' @description
#' This is a set of functions for mutual conversion between Kyureki that the lunar calendar and the calendar, the former calendar system of Japan. Kyureki the lunar calendar here is a calendar system that was never actually used, assuming that the Tenpo calendar was extended after the 6th year of Meiji.
#'
#' @param date Date to be converted. It should always include the year, month, and day.
#' @param calendar Select whether the calendar is Gregorian or Julian.
#' @param era Whether the Gengo of the Japanese calendar is the Southern or Northern dynasty system, the system used in the Kanto region, the Heike, and Kyoto respectively, or no era names.
#' @param one Whether to write the year in kanji as the first year or leave it as a number.
#' @param leap.month Whether to write leap months in Kanji or Hiragana.
#' @param sep The way the date is separated when the last date is written.
#'
#' @return String type date.
#'
#' @examples
#' seireki2kyureki("2021/1/1")
#' kyureki2seireki("\u4ee4\u548c3\u5e741\u67081\u65e5")
#'
#' @references
#' The data for the Kyureki calendar and era names refer to the following data.
#'
#' manakai/data-locale \url{https://github.com/manakai/data-locale}
#'
#' @rdname kyureki
#' @export

seireki2kyureki <- function(date,
                            calendar = c("gregorian", "julian"),
                            era = c("south", "north", "east", "heishi", "kyoto", "non"),
                            one = c("kanji", "number"),
                            leap.month = c("kanji", "hiragana"),
                            sep = c("kanji", "/", "-")){
  calendar <- match.arg(calendar)
  era <- match.arg(era)
  one <- match.arg(one)
  leap.month <- match.arg(leap.month)
  sep <- match.arg(sep)

  unname(sapply(date, function(date){
    if(leap.month == "kanji") suffix.leap <- "\u958f"
    else if(leap.month == "hiragana") suffix.leap <- "\u3046\u308b\u3046"

    n <- calendar2jdn(date, jdn = "jdn", calendar = calendar)

    if(n < kyureki_JDN[1, "month_01"]){
      warning("Entered a date older than the supported period.", call. = FALSE)
      return(NA)
    }else if(n >= kyureki_JDN[nrow(kyureki_JDN), "month_01"]){
      warning("Entered a date that is farther in the future than the supported dates.", call. = FALSE)
      return(NA)
    }

    y <- max(kyureki_JDN$kyureki_year[kyureki_JDN$month_01 <= n])
    m <- which(kyureki_JDN[y,] == max(kyureki_JDN[y,][kyureki_JDN[y,] <= n], na.rm = TRUE)) - 2

    if(!is.na(kyureki_JDN[y,"leap_month"])){
      if(m == kyureki_JDN[y, "leap_month"] + 1) m <- paste(suffix.leap, m - 1 , sep = "")
      else if(m > kyureki_JDN[y, "leap_month"] + 1) m <- m - 1
    }

    d <- n - max(kyureki_JDN[y,][kyureki_JDN[y,] <= n], na.rm = TRUE) + 1

    if(era == "south") era.data <- era_south
    else if(era == "north") era.data <- era_north
    else if(era == "east") era.data <- era_east
    else if(era == "heishi") era.data <- era_heishi
    else if(era == "kyoto") era.data <- era_kyoto

    if(era != "non" &&  n< era.data$JDN[1]){
      warning("An older date than the oldest supported era names is specified.", call. = FALSE)
      return(NA)
    }

    if(era != "non"){
      era.mark <- era.data$era_name[which(era.data$kyureki_year == max(era.data$kyureki_year[era.data$JDN <= n]))]
      era.year <- y - max(era.data$kyureki_year[era.data$JDN <= n]) + 1
      if(one == "kanji" && era.year == 1) era.year <- "\u5143"
      y <- paste(era.mark, era.year, sep = "")
    }

    if(sep == "kanji")
      ans <- paste(y, "\u5e74", m, "\u6708", d, "\u65e5", sep = "")
    else ans <- paste(y, m, d, sep = sep)

    ans
  }))
}

#' @rdname kyureki
#' @export

kyureki2seireki <- function(date,
                            calendar = c("gregorian", "julian"),
                            era = c("south", "north", "east", "heishi", "kyoto", "non"),
                            sep = "/"){
  calendar <- match.arg(calendar)
  era <- match.arg(era)

  unname(sapply(date, function(date){
    if(length(grep("\u5143\u5e74", date)) > 0) date <- sub("\u5143\u5e74" , "1\u5e74", date)
    else if(length(grep("\u5143/", date)) > 0) date <- sub("\u5143/", "1/", date)
    else if(length(grep("\u5143-", date)) > 0) date <- sub("\u5143-", "1-", date)

    date <- gsub("\u5e74|\u6708|-", "/", date)
    date <- gsub("\u65e5", "", date)

    if(era == "south") era.data <- era_south
    else if(era == "north") era.data <- era_north
    else if(era == "east") era.data <- era_east
    else if(era == "heishi") era.data <- era_heishi
    else if(era == "kyoto") era.data <- era_kyoto

    date.number <- strsplit(date, split = "/")[[1]]

    y <- date.number[1]
    m <- date.number[2]
    d <- as.numeric(date.number[3])

    if(era != "non"){
      era.mark <- strsplit(y, split = "[[:digit:]]")[[1]][1]
      era.year <- strsplit(y, split = "[^[:digit:]]")[[1]]
      era.year <- as.numeric(era.year[era.year != ""])
      if(is.na(match(era.mark, era.data$era_name))){
        warning("An unsupported original era name is entered. Only era names after Emperor Keiko are supported.", call. = FALSE)
        return(NA)
      }
      y <- era.data$kyureki_year[era.data$era_name == era.mark] + era.year - 1
    }else{
      if(is.na(suppressWarnings(as.numeric(y)))){
        warning("Something other than a number has been entered for the number of years.", call. = FALSE)
        return(NA)
      }
      if(as.numeric(y) < kyureki_JDN[1, "kyureki_year"]){
        warning("Entered a date older than the supported period.", call. = FALSE)
        return(NA)
      }
      else y <- as.numeric(y)
    }

    if(kyureki_JDN[nrow(kyureki_JDN), "kyureki_year"] <= y){
      warning("Entered a date that is farther in the future than the supported dates.", call. = FALSE)
      return(NA)
    }

    if(number_kyureki.month(y, m, era = "non") < d){
      warning("The number of days entered does not exist for the month.", call. = FALSE)
      return(NA)
    }

    if(!is.na(kyureki_JDN$leap_month[kyureki_JDN$kyureki_year == y])){
      if(length(grep("\u958f|\u3046\u308b\u3046", m)) > 0 && as.numeric(strsplit(m, split = "\u958f|\u3046\u308b\u3046")[[1]][2]) == kyureki_JDN$leap_month[kyureki_JDN$kyureki_year == y]) m <- as.numeric(strsplit(m, split = "\u958f|\u3046\u308b\u3046")[[1]][2]) + 1
      else if((length(grep("\u958f|\u3046\u308b\u3046", m)) > 0 && as.numeric(strsplit(m, split = "\u958f|\u3046\u308b\u3046")[[1]][2]) != kyureki_JDN$leap_month[kyureki_JDN$kyureki_year == y])){
        warning("That month of the year is not a leap month.", call. = FALSE)
        return(NA)
      }else if(as.numeric(m) > kyureki_JDN$leap_month[kyureki_JDN$kyureki_year == y]) m <- as.numeric(m) + 1
      else m <- as.numeric(m)
    }else if(length(grep("\u958f|\u3046\u308b\u3046", m)) > 0){
      warning("There are no leap months in that year.", call. = FALSE)
      return(NA)
    }else m <- as.numeric(m)

    n <- kyureki_JDN[y, m + 2] + d - 1
    ans <- jdn2calendar(n = n, jdn = "jdn", calendar = calendar, sep = sep)

    ans
  }))
}
