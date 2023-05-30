library(pls)
library(caret)
set.seed(123)

# Load data
weather = read.csv('data/weather.csv')[,2:10]
rent = read.csv('data/date_by_rent.csv')[,2:3]
names(rent) = c('date', 'rent_count')

# combine weather and rent data
# snow값을 제외하는 것이 더 효율적인지 고민이 필요함.
df = merge(weather, rent, by='date', all=TRUE)
df = subset(df, select=-c(date, snow))
pairs(df)

# split test data
train_indexs = createDataPartition(df$rent_count, p=0.85, list=F)
train_set = df[train_indexs, ]
test_set = df[-train_indexs, ]

#PLS
pls.fit = plsr(rent_count ~ ., data=df, scale=TRUE, subset=train_indexs, validation="CV")

# 차원이 증가할 때 마다 MSEP가 점점 감소하고 있다.
# 모든 변수를 사용했을 때(7개) 선형모델(lm)과 동일한 MSE를 보인다. 
validationplot(pls.fit, val.type="MSEP")
summary(pls.fit)

# 모든변수를 사용했을 때(ncomp=7) pls.mse는 선형모델과 같다.
pls.pred = predict(pls.fit, ncomp=5, newdata=test_set)
pls.mse = mean((test_set$rent_count - pls.pred)^2)
pls.mse

