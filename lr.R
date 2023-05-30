library(pls)
library(caret)
library(car)
set.seed(123)

# Load data. 1번열(index)값을 제외하고 가져온다.
weather = read.csv('data/weather.csv')[,2:10]
rent = read.csv('data/date_by_rent.csv')[,2:3]
names(rent) = c('date', 'rent_count')

# standardize weather data
cols_to_standardize <- setdiff(names(weather), "date")
weather[cols_to_standardize] <- scale(weather[cols_to_standardize])


# combine weather and rent data
df = merge(weather, rent, by='date', all=TRUE)
df = subset(df, select=-c(date, snow))

pairs(df)
summary(df)

# split test data
# train_indexs = createDataPartition(df$rent_count, p=0.6, list=F)
train_indexs <- seq(1, nrow(df), 2)
train_set = df[train_indexs, ]
test_set = df[-train_indexs, ]

# LR
lm.fit = lm(rent_count ~ ., data=df, subset=train_indexs)
summary(lm.fit) # Multiple R-squared:  0.8024,	Adjusted R-squared:  0.786

# 모델에 유의미하지 않은 변수들을 제외한 모델
lm.fit2 = lm(rent_count ~ temp_mean + rain_hour + sun_hour + cloud, data=df, subset=train_indexs)
summary(lm.fit2) 

extractAIC(lm.fit, k=2)  # 1872.433
extractAIC(lm.fit2, k=2) # 1868.697

extractAIC(lm.fit, k=log(nrow(lm.fit2$model)))  # 1892.608
extractAIC(lm.fit2, k=log(nrow(lm.fit2$model))) # 1881.306

library(car)
vif(lm.fit2)

par(mfrow=c(2,2)) # 그래프를 2 x 2 격자로 그리겠다.
plot(lm.fit2)
