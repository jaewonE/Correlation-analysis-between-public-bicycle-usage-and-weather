# rbind 를 사용하기 위해 라이브러리 로드
library(dplyr)

# 대여소에 따른 대여횟수을 저장할 빈 데이터프레임을 선언
station_by_rent = data.frame(
  station = character(),
  count = integer(),
  stringsAsFactors = FALSE
)

# data/bike 폴더 내부에 있는 파일(대여 정보)을 하나씩 가져온다.
for (file in list.files('data/bike')) {
  
  # 파일에 접근할 수 있는 주소(file_path) 생성
  file_path = paste('data/bike/', file, sep='')
  print(paste("Reading file:", file))
  
  # csv 파일을 불러온다.
  data = read.csv(file_path, fileEncoding="cp949")
  
  # 각 대여소에 따른(그룹화하여) 대여횟수를 측정한다.
  grouped_station <- data %>%
    group_by(data[['대여대여소ID']]) %>%
    summarise(count = n())
  
  # 열의 이름을 순서대로 station, count로 변경해준다.
  # 변경 전에는 data[['대여대여소ID']], count 이다.
  names(grouped_station) = c('station', 'count')
  
  # grouped_station을 station_by_rent에 세로로 합친다. 
  station_by_rent = rbind(station_by_rent, grouped_station)
}

# station 열에 중복된 값이 존재할 경우 count값을 모두 더한 뒤 
# 하나의 station(대여소ID)값만을 남긴다. 
station_by_rent = aggregate(count ~ station, data = station_by_rent, FUN = sum)

# 대여소에 따른 사용횟수인 date_by_station 데이터프레임을 출력한다.
# n=dim(date_by_station)[1] 을 통해 출력할 행의 개수를 설정할 수 있다.
# dim(date_by_station)[1] 은 행의 개수이다. 
print(station_by_rent)

# CSV로 저장한다. 
write.csv(station_by_rent, 'data/station_by_rent.csv')
print("Write data/station_by_rent.csv file")
