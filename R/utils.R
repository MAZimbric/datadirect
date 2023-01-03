format_time <- function(data, time_col = raw_datetime) {
  data <- dplyr::mutate(data,
                        date = date(mdy_hm(raw_datetime)),
                time = hms::as_hms(mdy_hm(raw_datetime))) %>%
    dplyr::select(-raw_datetime)
  return(data)
}
