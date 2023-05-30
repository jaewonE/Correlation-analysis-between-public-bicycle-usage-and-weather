rent_by_age_df = NULL

# data/bike 폴더 내부에 있는 파일(대여 정보)을 하나씩 가져온다.
for (file in list.files('data/bike')) {
  
  # 파일에 접근할 수 있는 주소(file_path) 생성
  file_path = paste('data/bike/', file, sep='')
  print(paste("Reading file:", file))

  rent = read.csv(file_path, fileEncoding='cp949')
  
  data = rent[,c("생년","성별")]
  data$생년 = as.integer(data$생년)
  data = data[!(data$생년=="\\N" | data$성별=="\\N"),]
  data = data[!(data$성별==" "),]
  data = data[(data$성별=="F" | data$성별=="M"),]
  data = na.omit(data)
  
  data = data[(data$생년 >= 1924 & data$생년 < 2023),]
  data$age = 2023 - data$생년
  data$age_general = data$age - (data$age %% 10)
  
  count_table = as.numeric(table(data$age_general))
  rent_age = c()
  rent_age = append(rent_age, count_table[1] + count_table[2])
  for(i in c(3,4,5,6)) 
    rent_age = append(rent_age, count_table[i])
  rent_age = append(rent_age, count_table[7] + count_table[8] + count_table[9] + count_table[10])
  
  age_ranges <- c("~10", "20", "30", "40", "50", "60+")
  
  rent_by_age_total = data.frame(rent_age, age_ranges)
  
  # 이어붙이기
  if(isTRUE(rent_by_age_df) && is.null(rent_by_age_df)) {
    rent_by_age_df = rent_by_age_total
  } else{
    rent_by_age_df = rbind(rent_by_age_df, rent_by_age_total)
  }
}

rent_by_age_df

# 그래프로 출력
ggplot(rent_by_age_df, aes(x = age_ranges, y = rent_age, fill = rent_age)) +
  geom_bar(stat = "identity") +
  labs(x = "Age", y = "Number of rents") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_gradient(low = "#e1bee7", high = "#7b1fa2")  # Specifies the color gradient

