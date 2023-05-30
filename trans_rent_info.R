library(dplyr)

# 날짜에 따른 사용횟수을 저장할 빈 데이터프레임을 선언
date_by_rent = data.frame(
  rent_date = as.Date(character(), format = "%Y-%m-%d"),
  count = integer(),
  stringsAsFactors = FALSE
)

# 대여소에 따른 사용횟수을 저장할 빈 데이터프레임을 선언
station_by_rent = data.frame(
  station = character(),
  count = integer(),
  stringsAsFactors = FALSE
)


for (file in list.files('data/bike')) {
  # Set file path
  file_path = paste('data/bike/', file, sep='')
  print(paste("Reading file:", file))
  
  # Load data
  data = read.csv(file_path, fileEncoding="cp949")
  data['rent_date'] = as.Date(data$대여일시)
  
  # 각 날짜에 따른(그룹화하여) 대여횟수를 측정한다.
  grouped_df <- data %>%
    group_by(rent_date) %>%
    summarise(count = n())
  date_by_rent = rbind(date_by_rent, grouped_df)
  
  # 각 대여소에 따른(그룹화하여) 대여횟수를 측정한다.
  grouped_station <- data %>%
    group_by(data[['대여대여소ID']]) %>%
    summarise(count = n())
  names(grouped_station) = c('station', 'count')
  station_by_rent = rbind(station_by_rent, grouped_station)
  
}

# 날짜에 따른 대여횟수를 CSV로 저장한다.
write.csv(date_by_rent, 'data/date_by_rent.csv', row.names = FALSE)
print("Write data/date_by_rent.csv file")

# 대여소에 따른 대여횟수를 CSV로 저장한다. 
station_by_rent = aggregate(count ~ station, data = station_by_rent, FUN = sum)
write.csv(station_by_rent, 'data/station_by_rent.csv', row.names = FALSE)
print("Write data/station_by_rent.csv file")
