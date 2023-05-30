library(lubridate)
library(dplyr)

rent_by_hour = NULL

# data/bike 폴더 내부에 있는 파일(대여 정보)을 하나씩 가져온다.
for (file in list.files('data/bike')) {
  
  # 파일에 접근할 수 있는 주소(file_path) 생성
  file_path = paste('data/bike/', file, sep='')
  print(paste("Reading file:", file))
  
  # Load csv
  rent <- read.csv(file_path, fileEncoding="cp949")
  
  # 대여일시 열에서 시각만 추출하여 hour 열에 저장
  rent$hour = format(as.POSIXct(rent$대여일시), format="%H")
  
  # 각 시간대에 대란 개수 측정 값을 데이터프레임 타입으로 저장
  rent_hour = as.data.frame(table(rent$hour))
  # 열의 이름을 변경(통일을 위치)
  colnames(rent_hour) = c('hour', 'count')
  
  # 이어붙이기
  if(isTRUE(rent_by_hour) && rent_by_hour == NULL) {
    rent_by_hour = rent_hour
  } else{
    rent_by_hour = rbind(rent_by_hour, rent_hour)
  }
}

# 그래프로 표시
ggplot(rent_by_hour, aes(x = hour, y = count, fill = count)) +
  geom_bar(stat = "identity") +
  labs(x = "Hour", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_gradient(low = "#ffcccc", high = "#cc0000")  # Specifies the color gradient
