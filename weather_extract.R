
# 날씨데이터 중 7월 1일 ~ 12월 31일 정보만 가져온다. 
weather = read.csv('data/seoul_weather_2022.csv', fileEncoding = 'cp949')[c(182:365),]

# 각 날짜를 가지는 빈 dataframe 생성
df = data.frame(matrix(nrow=nrow(weather), ncol=0))
df['date'] = weather['일시']

# 평균기온(NA가 없다)
# if(length(weather['평균기온..C.'][is.na(weather['평균기온..C.'])]) != 0)
#   weather['평균기온..C.'][is.na(weather['평균기온..C.'])] = 0
df['temp_mean'] = weather['평균기온..C.']

# 일교차
df['temp_gap'] = weather['최고기온..C.'] - weather['최저기온..C.']
# 일교차는 2022-08-08 에서 NA값을 하나 가지고 있다.
df[is.na(df['temp_gap'])]
# 2022-08-09의 일교차와 2022-08-07의 일교차의 평균을 해당값에 대입한다.
df['temp_gap'][is.na(df['temp_gap'])] = (
  (df['temp_gap'][df['date'] == '2022-08-07'] + 
  df['temp_gap'][df['date'] == '2022-08-09']) / 2.0
)

# 강수계속시간
# 본 데이터 세트에서 강수와 공공자전거 이용률 간의 상관관계는 '일강수량(mm)' 값을 
# 통해 분석하는 것이 더 타당한 것으로 판단된다. 하지만 '강수 계속시간(hr)'이 
# 0 이상(비가 왔다)임에도 '일강수량(mm)' 값이 0인 오류를 내포하고 있음으로 
# '강수 계속시간(hr)'이 더 올바르게 측정된 자료라고 판단할 수 있다. 
# 이에 '일강수량(mm)' 대신 '강수 계속시간(hr)'값을 통해 강수와 공공자전거 이용률 간의 상관관계를 분석한다.
if(length(weather['강수.계속시간.hr.'][is.na(weather['강수.계속시간.hr.'])]) != 0) 
  weather['강수.계속시간.hr.'][is.na(weather['강수.계속시간.hr.'])] = 0
df['rain_hour'] = weather['강수.계속시간.hr.']

# 평균상대습도(NA가 없다)
# if(length(weather['평균.상대습도...'][is.na(weather['평균.상대습도...'])]) != 0) 
#   weather['평균.상대습도...'][is.na(weather['평균.상대습도...'])] = 0
df['humidity_mean'] = weather['평균.상대습도...']

# 적설량
if(length(weather['일.최심적설.cm.'][is.na(weather['일.최심적설.cm.'])]) != 0) 
  weather['일.최심적설.cm.'][is.na(weather['일.최심적설.cm.'])] = 0
df['snow'] = weather['일.최심적설.cm.']

# 가조시간(NA가 없다)
# if(length(weather['가조시간.hr.'][is.na(weather['가조시간.hr.'])]) != 0) 
#   weather['가조시간.hr.'][is.na(weather['가조시간.hr.'])] = 0
df['sun_hour'] = weather['가조시간.hr.']

# 평균풍속(NA가 없다)
# if(length(weather['평균.풍속.m.s.'][is.na(weather['평균.풍속.m.s.'])]) != 0) 
#   weather['평균.풍속.m.s..'][is.na(weather['평균.풍속.m.s.'])] = 0
df['wind_speed'] = weather['평균.풍속.m.s.']

# 평균 전운량 (NA가 없다) + 그래프로 그래보면 가조시간과 같은 계절에 따른 분포가 없다.
# if(length(weather['평균.전운량.1.10.'][is.na(weather['평균.전운량.1.10.'])]) != 0) 
#   weather['평균.전운량.1.10.'][is.na(weather['평균.전운량.1.10.'])] = 0
df['cloud'] = weather['평균.전운량.1.10.']

# Write CSV
print("Write CSV: data/weather.csv")
write.csv(df, 'data/weather.csv')
head(df, 10)