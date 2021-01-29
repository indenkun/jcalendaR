#' jcalendaR-utils
#' @description
#' This is a set of utility functions related to the Kyureki calendar. `number_kyureki.month()` checks how many days there were in a month by specifying the number of years and months in the Kyureki calendar. `exixtence_leap.month()` checks if there was a leap month in a year by entering the number of years in the Kyureki calendar.
#' `era.name()` will output the era names of the corresponding year in this package.
#'
#' @param kyureki.year The number of years in the Kyureki calendar to check.
#' @param kyureki.month The number of strings of months in the Kyureki calendar to check.
#' @param era Whether the Gengo of the Japanese calendar is the Southern or Northern dynasty system, the system used in the Kanto region, the Heike, and Kyoto respectively, or no era names.
#'
#' @rdname jcalendaR-utils
#' @export


number_kyureki.month <- function(kyureki.year, kyureki.month, era = c("south", "north", "east", "heishi", "kyoto", "non")){
  era <- match.arg(era)

  unname(mapply(function(kyureki.year, kyureki.month){
    if(era == "south") era.data <- era_south
    else if(era == "north") era.data <- era_north
    else if(era == "east") era.data <- era_east
    else if(era == "heishi") era.data <- era_heishi
    else if(era == "kyoto") era.data <- era_kyoto

    if(era != "non"){
      if(!is.character(kyureki.year)){
        warning("For the argument of `era`, a value other than `non` is selected, but the era is not entered.")
        return(NA)
      }
      era.mark <- strsplit(kyureki.year, split = "[[:digit:]]")[[1]][1]
      era.year <- strsplit(kyureki.year, split = "[^[:digit:]]")[[1]]
      era.year <- as.numeric(era.year[era.year != ""])
      if(is.na(match(era.mark, era.data$era_name))){
        warning("An unsupported original era name is entered. Only era names after Emperor Keiko are supported.", call. = FALSE)
        return(NA)
      }
      kyureki.year <- era.data$kyureki_year[era.data$era_name == era.mark] + era.year - 1
    }else kyureki.year <- as.numeric(kyureki.year)

    if(existence_leap.month(kyureki.year = kyureki.year, existence = "logical", era = "non")){
      if(length(grep("\u958f|\u3046\u308b\u3046", kyureki.month)) > 0 && as.numeric(strsplit(kyureki.month, split = "\u958f|\u3046\u308b\u3046")[[1]][2]) == kyureki_JDN$leap_month[kyureki_JDN$kyureki_year == kyureki.year]) m <- as.numeric(strsplit(kyureki.month, split = "\u958f|\u3046\u308b\u3046")[[1]][2]) + 1
      else if((length(grep("\u958f|\u3046\u308b\u3046", kyureki.month)) > 0 && as.numeric(strsplit(kyureki.month, split = "\u958f|\u3046\u308b\u3046")[[1]][2]) != kyureki_JDN$leap_month[kyureki_JDN$kyureki_year == kyureki.year])){
        warning("That month of the year is not a leap month.", call. = FALSE)
        return(NA)
      }else if(as.numeric(kyureki.month) > kyureki_JDN$leap_month[kyureki_JDN$kyureki_year == kyureki.year]) m <- as.numeric(kyureki.month) + 1
      else m <- as.numeric(kyureki.month)
    }else if(length(grep("\u958f|\u3046\u308b\u3046", kyureki.month)) > 0){
      warning("There are no leap months in that year.", call. = FALSE)
      return(NA)
    }else m <- as.numeric(kyureki.month)

    if(m == 13 || is.na(kyureki_JDN[kyureki.year, m + 3])) number.day <- kyureki_JDN[kyureki.year + 1, "month_01"] - kyureki_JDN[kyureki.year, m + 2]
    else number.day <- kyureki_JDN[kyureki.year, m + 3] - kyureki_JDN[kyureki.year, m + 2]
    ans <- number.day

    ans
  }, kyureki.year, kyureki.month))
}

#' @param existence Whether to return the existence of a leap month as a theoretical type or as a leap month number.
#' @rdname jcalendaR-utils
#' @export

existence_leap.month <- function(kyureki.year, existence = c("logical", "number"), era = c("south", "north", "east", "heishi", "kyoto", "non")){
  existence <- match.arg(existence)
  era <- match.arg(era)

  unname(sapply(kyureki.year, function(kyureki.year){
  if(era == "south") era.data <- era_south
  else if(era == "north") era.data <- era_north
  else if(era == "east") era.data <- era_east
  else if(era == "heishi") era.data <- era_heishi
  else if(era == "kyoto") era.data <- era_kyoto

  if(era != "non"){
    era.mark <- strsplit(kyureki.year, split = "[[:digit:]]")[[1]][1]
    era.year <- strsplit(kyureki.year, split = "[^[:digit:]]")[[1]]
    era.year <- as.numeric(era.year[era.year != ""])
    if(is.na(match(era.mark, era.data$era_name))){
      warning("An unsupported original era name is entered. Only era names after Emperor Keiko are supported.", call. = FALSE)
      return(NA)
    }
    kyureki.year <- era.data$kyureki_year[era.data$era_name == era.mark] + era.year - 1
  }else kyureki.year <- as.numeric(kyureki.year)

  leap.month <- kyureki_JDN[kyureki.year, 2]

  if(existence == "logical") ans <- as.vector(!is.na(leap.month))
  else if(existence == "number") ans <- as.numeric(leap.month)

  ans
  }))
}

#' @rdname jcalendaR-utils
#' @export

era.name <- function(era = c("south", "north", "east", "heishi", "kyoto")){
  era <- match.arg(era)

  if(era == "south") era.data <- era_south
  else if(era == "north") era.data <- era_north
  else if(era == "east") era.data <- era_east
  else if(era == "heishi") era.data <- era_heishi
  else if(era == "kyoto") era.data <- era_kyoto

  unique(era.data$era_name)
}
