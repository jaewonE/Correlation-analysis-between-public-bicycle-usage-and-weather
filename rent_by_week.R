library(dplyr)
library(lubridate)

# 날짜에 따른 대여횟수을 저장할 빈 데이터프레임을 선언
rent_by_week = data.frame(
  week_start = as.Date(character(), format = "%Y-%m-%d"),
  total_count = integer(),
  stringsAsFactors = FALSE
)

# data/bike 폴더 내부에 있는 파일(대여 정보)을 하나씩 가져온다.
for (file in list.files('data/bike')) {
  
  # 파일에 접근할 수 있는 주소(file_path) 생성
  file_path = paste('data/bike/', file, sep='')
  print(paste("Reading file:", file))
  
  # Load csv
  rent <- read.csv(file_path, fileEncoding="cp949")
  
  # trans to Date type of 대여일시 column
  rent['date'] = as.Date(rent$대여일시)
  
  # 날짜에 따른 그룹화
  rent_by_date <- rent %>% group_by(date) %>% summarise(count = n())
  
  # 한 주의 시작(월요일) 날짜에 따른 라벨링
  rent_by_date$week_start <- rent_by_date$date - days(wday(rent_by_date$date) - 2)
  
  # 각 주차에 따른 그룹화
  weekly_counts <- rent_by_date %>%
    group_by(week_start = floor_date(week_start, "week", week_start=1)) %>%
    summarize(total_count = sum(count))
  
  # bind
  rent_by_week = rbind(rent_by_week, weekly_counts)
}

# 그래프로 출력
ggplot(rent_by_week, aes(x = week_start, y = total_count, fill = total_count)) +
  geom_bar(stat = "identity") +
  labs(x = "Date", y = "Number of Rentals") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_gradient(low = "lightblue", high = "darkblue")  # Specifies the color gradient
