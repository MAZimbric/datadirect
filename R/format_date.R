## code for fixing dates
dplyr::mutate(date = lubridate::date(lubridate::mdy_hm(raw_datetime)),
              time = hms::as_hms(lubridate::mdy_hm(raw_datetime)))%>%
