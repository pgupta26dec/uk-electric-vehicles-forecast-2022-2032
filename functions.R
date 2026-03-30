#Download data from ONS site
download_from_ons_function <- function(file_name, url, download_directory_ = download_directory){
  
  #Download file
  download.file(
    url,
    paste0("input/", file_name),
    method = "auto",
    #Mode needs changing on Windows machines
    #This allows it to download binary files correctly)
    mode = "wb")
  
}

convert_to_date_format <- function(x){
  #splitted_x <- unlist(str_split(x, " "))
  temp_date <- paste0(word(x,1), " ", word(x,2))
  
  new_date <- as.Date(as.yearqtr(temp_date, format = "%Y Q%q"))
  return(new_date)
  
  #return(paste0(word(x,1), " ", word(x,2)))
         #, " ", unlist(str_split(x, " "))[2]))
}

convert_quarterly_data_to_iso <- function(x){
  new_date <- as.Date(as.yearqtr(x, format = "%Y Q%q"))
  return(new_date)
}
