# rbind 를 사용하기 위해 라이브러리 로드
library(dplyr)

# 날짜에 따른 대여횟수을 저장할 빈 데이터프레임을 선언
date_by_rent = data.frame(
  rent_date = as.Date(character(), format = "%Y-%m-%d"),
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
  
  # 대여일시 열을 Date 클래스로 변경한 값을 rent_date 라는 열을 생성하여 저장한다.
  # class(data$rent_date) 를 통해 확인할 수 있다.
  data['rent_date'] = as.Date(data$대여일시)
  
  # 각 날짜에 따른(그룹화하여) 대여횟수를 측정한다.
  grouped_df <- data %>%
    group_by(rent_date) %>%
    summarise(count = n())
  
  # grouped_df를 date_by_rent에 세로로 합친다.
  date_by_rent = rbind(date_by_rent, grouped_df)
}

# 날짜에 따른 사용횟수인 date_by_rent 데이터프레임을 출력한다.
# n=dim(date_by_rent)[1] 을 통해 출력할 행의 개수를 설정할 수 있다.
# dim(date_by_rent)[1] 은 행의 개수이다. 
print(date_by_rent, n=dim(date_by_rent)[1])

# CSV로 저장
# write.csv(date_by_rent, 'data/date_by_rent.csv')
print("Write data/date_by_rent.csv file")


