micro_columns <- list(patient_ID = "PatientID",
                      encounter = "EncounterID",
                      accn = "ACCESSION_NUMBER",
                      raw_date_time = "COLLECTION_DATE",
                      code = "RESULT_CODE",
                      result = "VALUE",
                      text = "RESULT_COMMENT")

#' Load a csv of microbiology data
#'
#' @param culture_file String of path to raw culture results file.
#' @param pt_file String of path to patient identifier file.
#' @param lab_key String of path to lab assigned patient identifier/MRN key.
#' @param columns Named list of columns to select from, default value already set.
#'
#' @return
#' @export
#'
#' @examples
micro_load_csv <- function(culture_file,
                           pt_file,
                           lab_key = NULL,
                           columns = micro_columns){
  ## load environment and data ##
  raw_data <- read_csv(file = culture_file)
  pt_key <- read_csv(file = pt_file, colClasses = "character")

  data <- raw_data %>%
    dplyr::select(!!!columns) %>%
    dplyr::mutate(date = date(mdy_hm(raw_datetime)),
           time = hms::as_hms(mdy_hm(raw_datetime)))%>%
    dplyr::left_join(pt_key) %>%
    dplyr::select(-PatientID, -raw_datetime)

  if(!is_null(lab_key)){
    lab_key <- read_csv(file = lab_key, colClasses = "character")
    if(is_null(lab_key$MRN))
      stop("MRN column not found in key_")
    else{
      data <- data %>%
        dplyr::left_join(lab_key) %>%
        select(-MRN)
      ### rename retroid to PatientID
    }
  }

  ## standardize patient identifier column
  else{
    data <- data %>%
      dplyr::rename(PatientID = MRN)
  }
  return(data)
}
