micro_columns <- list(PatientID = "PatientID",
                      encounter = "EncounterID",
                      accn = "ACCESSION_NUMBER",
                      raw_datetime = "COLLECTION_DATE",
                      code = "RESULT_CODE",
                      result = "VALUE",
                      text = "RESULT_COMMENT")

#' Load a csv of datadirect data
#'
#' @param culture_file String of path to raw culture results file.
#' @param pt_file String of path to patient identifier file.
#' @param lab_key String of path to lab assigned patient identifier/MRN key.
#' @param columns Named list of column names as strings to select from
#'
#' @return
#' @export
#'
#' @examples
load_csv <- function(culture_file,
                     pt_file,
                     #lab_key = NULL,
                     columns,
                     key_columns = list(PatientID = "PatientID",
                                        MRN = "MRN")){
  ## load environment and data ##
  raw_data <- read.csv(file = culture_file)
  raw_key <- read.csv(file = pt_file, colClasses = "character") %>%

  pt_key <- raw_key %>%
    dplyr::select(!!!key_columns)

  data <- raw_data %>%
    dplyr::select(!!!columns) %>%
    dplyr::left_join(pt_key) %>%
    dplyr::select(-PatientID, -raw_datetime)

  # if(!is_null(lab_key)){
  #   lab_key <- read_csv(file = lab_key, colClasses = "character")
  #   if(is_null(lab_key$MRN))
  #     stop("MRN column not found in key_")
  #   else{
  #     data <- data %>%
  #       dplyr::left_join(lab_key) %>%
  #       select(-MRN)
  #     ### rename retroid to PatientID
  #   }
  # }
  #
  # ## standardize patient identifier column
  # else{
  #   data <- data %>%
  #     dplyr::rename(PatientID = MRN)
  # }
  return(data)
}


